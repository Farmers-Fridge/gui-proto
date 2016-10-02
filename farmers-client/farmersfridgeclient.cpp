#include "farmersfridgeclient.h"
#include "httpdownloader.h"
#include <cxmlnode.h>
#include <utils.h>
#include <QMetaObject>

typedef int (FarmersFridgeClientPrivate::*memberf_pointer)();

// Log message:
void FarmersFridgeClientPrivate::LOG_MESSAGE(const QString &sMessage)
{
    if (!SILENT)
        qDebug() << sMessage;
}

// Constructor:
FarmersFridgeClientPrivate::FarmersFridgeClientPrivate(QObject *parent) : QObject(parent),
    m_sServerUrl(""),
    m_sAPIKey("")
{

}

// Retrieve server data:
void FarmersFridgeClientPrivate::retrieveServerData(
        const QString &sServerUrl,
        const QString &sAPIKey,
        const QString &sDstDir)
{
    // Initialize members:
    m_sServerUrl = sServerUrl;
    m_sAPIKey = sAPIKey;
    m_dstDir.setPath(sDstDir);
    m_dstDir.mkpath(SERVER_DIR);
    m_dstDir.cd(SERVER_DIR);

    // Build query:
    QString sQuery = QString("https://%1%2").arg(sServerUrl).arg(CATEGORY_SOURCE);
    download(QUrl(sQuery), m_dstDir, &FarmersFridgeClientPrivate::onHeadCategoryListDownloaded, HttpWorker::HEAD);
}

// Process categories:
void FarmersFridgeClientPrivate::processCategories(const QString &sCategoriesFile)
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
        LOG_MESSAGE("FarmersFridgeClientPrivate::processCategories CATEGORY LIST IS EMPTY");
        return;
    }

    // Retrieve category data:
    retrieveCategoryData();
}

// Head category list downloaded:
void FarmersFridgeClientPrivate::onHeadCategoryListDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onHeadCategoryListDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalCategoriesFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalCategoriesFile, sPrevMd5Hash))
    {
        // Download:
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClientPrivate::onCategoryListDownloaded);
    }
    else
    {
        processCategories(sLocalCategoriesFile);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Category list downloaded:
void FarmersFridgeClientPrivate::onCategoryListDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onCategoryListDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Check reply:
    processCategories(pSender->localFilePath());

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Retrieve category data:
void FarmersFridgeClientPrivate::retrieveCategoryData()
{
    for (auto sCategory : m_vCategories)
        retrieveSingleCategoryData(sCategory);
}

// Retrieve single category data:
void FarmersFridgeClientPrivate::retrieveSingleCategoryData(const QString &sCategoryName)
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
            download(QUrl(sQuery), categoryDir, &FarmersFridgeClientPrivate::onHeadSingleCategoryDataDownloaded, HttpWorker::HEAD);
        }
    }
}

// Single category data downloaded:
void FarmersFridgeClientPrivate::onHeadSingleCategoryDataDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onHeadSingleCategoryDataDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleCategoryFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleCategoryFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClientPrivate::onSingleCategoryDataDownloaded);
    }
    else
    {
        processSingleCategory(sLocalSingleCategoryFile, pSender->dstDir());
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Process single category:
void FarmersFridgeClientPrivate::processSingleCategory(const QString &sLocalSingleCategoryFile, const QDir &dstDir)
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
            LOG_MESSAGE("FarmersFridgeClientPrivate::processSingleCategory() FOUND AN EMPTY ICON URL");
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
            LOG_MESSAGE("FarmersFridgeClientPrivate::processSingleCategory() FOUND AN EMPTY NUTRITION FACT URL");
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
void FarmersFridgeClientPrivate::onSingleCategoryDataDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Process single category:
    processSingleCategory(pSender->localFilePath(), pSender->dstDir());

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Download single icon:
void FarmersFridgeClientPrivate::downloadSingleIcon(const QString &sIconUrl, const QDir &dstDir)
{
    // Retrieve body:
    download(QUrl(sIconUrl), dstDir, &FarmersFridgeClientPrivate::onHeadSingleIconDownloaded, HttpWorker::HEAD);
}

// Download single nutrition fact:
void FarmersFridgeClientPrivate::downloadSingleNutritionFact(const QString &sNutritionUrl, const QDir &dstDir)
{
    download(QUrl(sNutritionUrl), dstDir, &FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded);
}

// Head single icon downloaded:
void FarmersFridgeClientPrivate::onHeadSingleIconDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onHeadSingleIconDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleIconFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleIconFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClientPrivate::onSingleIconDownloaded);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single icon downloaded:
void FarmersFridgeClientPrivate::onSingleIconDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleIconDownloaded() HTTPDOWNLOADER IS NULL");
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleIconDownloaded() FAILED TO DOWNLOAD: %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }
    else
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleIconDownloaded() DOWNLOADED: %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Head single nutrition fact downloaded:
void FarmersFridgeClientPrivate::onHeadSingleNutritionFactDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onHeadSingleNutritionFactDownloaded() FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Retrieve MD5 hash:
    QString sPrevMd5Hash = pSender->getHeaderInfo(MD5_HEADER_KEY);
    QString sLocalSingleNutritionFactFile = pSender->localFilePath();

    if (assetNeedUpdate(sLocalSingleNutritionFactFile, sPrevMd5Hash))
    {
        download(pSender->remoteUrl(), pSender->dstDir(), &FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single nutrition fact downloaded:
void FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded() FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded() FAILED TO DOWNLOAD %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }
    else
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleNutritionFactDownloaded() DOWNLOADED %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Time out:
void FarmersFridgeClientPrivate::onTimeOut()
{
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    updateDownLoaders(pSender);
}

// Update downloaders:
void FarmersFridgeClientPrivate::updateDownLoaders(HttpDownLoader *pDownloader)
{
    int nRemoved = m_vDownloaders.removeAll(pDownloader);
    if (nRemoved > 0)
        delete pDownloader;

    LOG_MESSAGE(QString("*** WAITING FOR %1 DOWNLOADERS TO COMPLETE ***").arg(m_vDownloaders.size()));
    if (m_vDownloaders.isEmpty())
        emit allDone();
}

// Does asset need update?
bool FarmersFridgeClientPrivate::assetNeedUpdate(const QString &sAssetFullPath,
                                                 const QString &sPrevMD5) const
{
    // File does not exist, need update:
    QFileInfo fi(sAssetFullPath);
    if (!fi.exists())
        return true;

    // Compute MD5 hash for file:
    QString sCurrentMD5 = Utils::fileCheckSum(sAssetFullPath);
    return sPrevMD5 != sCurrentMD5;
}

// Download:
void FarmersFridgeClientPrivate::download(const QUrl &url, const QDir &dstDir, CallBack callBack, const HttpWorker::RequestType &requestType)
{
    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, callBack);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);

    // Download:
    pDownLoader->download(url, dstDir, m_sAPIKey, requestType);
}

// Constructor:
FarmersFridgeClient::FarmersFridgeClient(QObject *parent) : QObject(parent),
    m_pFarmersFridgeClientPrivate(new FarmersFridgeClientPrivate(this))
{
    connect(m_pFarmersFridgeClientPrivate, &FarmersFridgeClientPrivate::allDone, this, &FarmersFridgeClient::allDone);
}

// Retrieve server data:
void FarmersFridgeClient::retrieveServerData(
        const QString &sDstDir,
        const QString &sServerUrl,
        const QString &sAPIKey)
{
    m_pFarmersFridgeClientPrivate->retrieveServerData(sServerUrl, sAPIKey, sDstDir);
}

// Ready:
void FarmersFridgeClient::onReady()
{
    qDebug() << "DOWNLOAD DONE";
}
