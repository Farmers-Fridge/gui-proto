// Application:
#include "farmersfridgeclient.h"
#include "httpdownloader.h"
#include <cxmlnode.h>
#include <utils.h>

// Qt:
#include <QMetaObject>

typedef int (FarmersFridgeClient::*memberf_pointer)();

// Log message:
void FarmersFridgeClient::LOG_MESSAGE(const QString &sMessage, const Message::MsgType &eMsgType)
{
    if (!SILENT)
        qDebug() << sMessage;
    m_vMessages << Message(sMessage, eMsgType);
}

// Constructor:
FarmersFridgeClient::FarmersFridgeClient(QObject *parent) : QObject(parent),
    m_sServerUrl(""),
    m_sAPIKey("")
{

}

// Retrieve server data:
void FarmersFridgeClient::retrieveServerData(
        const QString &sServerUrl,
        const QString &sAPIKey)
{
    LOG_MESSAGE(QString("RETRIEVING SERVER DATA ON %1").arg(QDateTime::currentDateTime().toString()), Message::INFO);

    // Initialize members:
    m_sServerUrl = sServerUrl;
    m_sAPIKey = sAPIKey;
    m_dstDir = Utils::appDir();
    if (m_dstDir.cdUp())
    {
        if (m_dstDir.mkpath(SERVER_DIR))
            m_dstDir.cd(SERVER_DIR);
    }

    // Build query:
    QString sQuery = QString("https://%1%2").arg(sServerUrl).arg(CATEGORY_SOURCE);
    download(QUrl(sQuery), m_dstDir, &FarmersFridgeClient::onHeadCategoryListDownloaded, HttpWorker::HEAD);
}

// Process categories:
void FarmersFridgeClient::processCategories(const QString &sCategoriesFile)
{
    // Parse:
    CXMLNode result = CXMLNode::load(sCategoriesFile);

    // Retrieve category list:
    foreach (CXMLNode item, result.nodes())
    {
        // Category name:
        CXMLNode categoryNode = item.getNodeByTagName("categoryName");
        QString sCategoryName = categoryNode.value();
        if (sCategoryName.simplified().isEmpty())
            continue;
        m_vCategories << sCategoryName;
    }

    // Retrieve category data:
    if (m_vCategories.isEmpty())
    {
        LOG_MESSAGE("CATEGORY LIST IS EMPTY", Message::ERROR);
        return;
    }

    // Retrieve category data:
    retrieveCategoryData();
}

// Head category list downloaded:
void FarmersFridgeClient::onHeadCategoryListDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalCategoriesFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalCategoriesFile, sPrevMd5Hash))
    {
        // Download:
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClient::onCategoryListDownloaded);
    }
    else
    {
        processCategories(sLocalCategoriesFile);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Category list downloaded:
void FarmersFridgeClient::onCategoryListDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Check reply:
    processCategories(pSender->localFilePath());

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Retrieve category data:
void FarmersFridgeClient::retrieveCategoryData()
{
    for (int i=0; i<m_vCategories.size(); i++)
        retrieveSingleCategoryData(m_vCategories[i]);
}

// Retrieve single category data:
void FarmersFridgeClient::retrieveSingleCategoryData(const QString &sCategoryName)
{
    // Build query:
    QString sCategorySource = QString("%1/%1.xml").arg(sCategoryName);
    QString sQuery = QString("https://%1%2").arg(m_sServerUrl).arg(sCategorySource);

    // Download:
    QDir categoryDir = m_dstDir;
    if (categoryDir.mkpath(sCategoryName))
    {
        if (categoryDir.cd(sCategoryName))
        {
            download(QUrl(sQuery), categoryDir, &FarmersFridgeClient::onHeadSingleCategoryDataDownloaded, HttpWorker::HEAD);
        }
    }
}

// Single category data downloaded:
void FarmersFridgeClient::onHeadSingleCategoryDataDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleCategoryFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleCategoryFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClient::onSingleCategoryDataDownloaded);
    }
    else
    {
        processSingleCategory(sLocalSingleCategoryFile, pSender->dstDir());
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Process single category:
void FarmersFridgeClient::processSingleCategory(const QString &sLocalSingleCategoryFile, const QDir &dstDir)
{
    // Parse:
    CXMLNode result = CXMLNode::load(sLocalSingleCategoryFile);

    // Parse icons:
    foreach (CXMLNode item, result.nodes())
    {
        // Icon:
        CXMLNode iconNode = item.getNodeByTagName("icon");

        // Icon url:
        QString sIconUrl = iconNode.value();
        if (sIconUrl.simplified().isEmpty())
        {
            LOG_MESSAGE("FOUND AN EMPTY ICON URL", Message::ERROR);
            continue;
        }

        // Download single icon:
        downloadSingleIcon(sIconUrl, dstDir);
    }

    // Parse nutrition facts:
    foreach (CXMLNode item, result.nodes())
    {
        // Nutrition:
        CXMLNode nutritionNode = item.getNodeByTagName("nutrition");

        // Nutrition url:
        QString sNutritionUrl = nutritionNode.value();
        if (sNutritionUrl.simplified().isEmpty())
        {
            LOG_MESSAGE("FOUND AN EMPTY NUTRITION FACT URL", Message::ERROR);
            continue;
        }

        QDir nutritionDir = dstDir;
        if (nutritionDir.mkpath("nutrition"))
        {
            if (nutritionDir.cd("nutrition"))
            {
                // Download single nutrition fact:
                downloadSingleNutritionFact(sNutritionUrl, nutritionDir);
            }
        }
    }
}

// Single category data downloaded:
void FarmersFridgeClient::onSingleCategoryDataDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Process single category:
    processSingleCategory(pSender->localFilePath(), pSender->dstDir());

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Download single icon:
void FarmersFridgeClient::downloadSingleIcon(const QString &sIconUrl, const QDir &dstDir)
{
    // Retrieve body:
    download(QUrl(sIconUrl), dstDir, &FarmersFridgeClient::onHeadSingleIconDownloaded, HttpWorker::HEAD);
}

// Download single nutrition fact:
void FarmersFridgeClient::downloadSingleNutritionFact(const QString &sNutritionUrl, const QDir &dstDir)
{
    download(QUrl(sNutritionUrl), dstDir, &FarmersFridgeClient::onHeadSingleNutritionFactDownloaded, HttpWorker::HEAD);
}

// Head single icon downloaded:
void FarmersFridgeClient::onHeadSingleIconDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleIconFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleIconFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClient::onSingleIconDownloaded);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single icon downloaded:
void FarmersFridgeClient::onSingleIconDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("HTTPDOWNLOADER IS NULL", Message::ERROR);
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FAILED TO DOWNLOAD: %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage, Message::ERROR);
    }
    else
    {
        QString sMessage = QString("DOWNLOADED: %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
        //LOG_MESSAGE(sMessage, Message::OK);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Head single nutrition fact downloaded:
void FarmersFridgeClient::onHeadSingleNutritionFactDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FAILED TO RETRIEVE HTTPDOWNLOADER", Message::ERROR);
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleNutritionFactFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleNutritionFactFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClient::onSingleNutritionFactDownloaded);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single nutrition fact downloaded:
void FarmersFridgeClient::onSingleNutritionFactDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FAILED TO RETRIEVE HTTPDOWNLOADER", Message::ERROR);
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FAILED TO DOWNLOAD %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage, Message::ERROR);
    }
    else
    {
        QString sMessage = QString("DOWNLOADED %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
        //LOG_MESSAGE(sMessage, Message::OK);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Time out:
void FarmersFridgeClient::onTimeOut()
{
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (pSender)
        LOG_MESSAGE(QString("TIMEOUT FOR: %1").arg(pSender->remoteUrl().toString()), Message::TIMEOUT);
    updateDownLoaders(pSender);
}

// Update downloaders:
void FarmersFridgeClient::updateDownLoaders(HttpDownLoader *pDownloader)
{
    if (pDownloader)
    {
        int nRemoved = m_vDownloaders.removeAll(pDownloader);
        if (nRemoved > 0)
            delete pDownloader;

        LOG_MESSAGE(QString("*** WAITING FOR %1 DOWNLOADERS TO COMPLETE ***").arg(m_vDownloaders.size()), Message::OK);

        if (m_vDownloaders.isEmpty()) {
            LOG_MESSAGE(QString("DONE RETRIEVING SERVER DATA ON: %1").arg(QDateTime::currentDateTime().toString()), Message::INFO);
            emit allDone();
        }
    }
}

// Does asset need update?
bool FarmersFridgeClient::assetNeedUpdate(const QString &sAssetFullPath,
                                                 const QString &sPrevMD5)
{
    // File does not exist, need update:
    QFileInfo fi(sAssetFullPath);
    if (!fi.exists()) {
        QString sMessage = QString("%1 NEED UPDATE").arg(sAssetFullPath);
        LOG_MESSAGE(sMessage, Message::NEED_UPDATE);
        return true;
    }

    // Compute MD5 hash for file:
    QString sCurrentMD5 = Utils::fileCheckSum(sAssetFullPath);
    bool test = sPrevMD5 != sCurrentMD5;
    QString sMessage = "";
    if (test) {
        sMessage = QString("%1 NEED UPDATE").arg(sAssetFullPath);
        LOG_MESSAGE(sMessage, Message::NEED_UPDATE);
    }
    else {
        sMessage = QString("%1 UP TO DATE").arg(sAssetFullPath);
        LOG_MESSAGE(sMessage, Message::DONT_NEED_UPDATE);
    }
    return test;
}

// Download:
void FarmersFridgeClient::download(const QUrl &url, const QDir &dstDir, CallBack callBack, const HttpWorker::RequestType &requestType)
{
    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, callBack);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClient::onTimeOut);

    // Download:
    pDownLoader->download(url, dstDir, m_sAPIKey, requestType);
}

// Return messages:
const QVector<Message> &FarmersFridgeClient::messages() const
{
    return m_vMessages;
}
