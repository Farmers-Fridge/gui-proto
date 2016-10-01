#include "farmersfridgeclient.h"
#include "httpdownloader.h"
#include <cxmlnode.h>

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
    // Remove current server dir:
    QDir dstDir(sDstDir);
    QString sServerDir = dstDir.absoluteFilePath(SERVER_DIR);
    QDir serverDir(sServerDir);
    if (serverDir.exists()) {
        bool test = serverDir.removeRecursively();
        if (!test) {
            QString sMsg = QString("armersFridgeClientPrivate::retrieveServerData FAILED TO REMOVE: %1").arg(sServerDir);
            LOG_MESSAGE(sMsg);
        }
    }

    // Initialize members:
    m_sServerUrl = sServerUrl;
    m_sAPIKey = sAPIKey;
    m_dstDir.setPath(sDstDir);
    m_dstDir.mkpath(SERVER_DIR);
    m_dstDir.cd(SERVER_DIR);

    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeClientPrivate::onCategoryListRetrieved);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);

    // Build query:
    QString sQuery = QString("https://%1%2").arg(sServerUrl).arg(CATEGORY_SOURCE);

    // Download:
    pDownLoader->download(QUrl(sQuery), m_dstDir, m_sAPIKey);
}

// Category list retrieved:
void FarmersFridgeClientPrivate::onCategoryListRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onCategoryListRetrieved FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Check reply:
    if (pSender->reply().isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onCategoryListRetrieved HTTPDOWNLOADER REPLY IS EMPTY");
        updateDownLoaders(pSender);
        return;
    }

    // Parse:
    CXMLNode result = CXMLNode::parseXML(pSender->reply());
    if (result.isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onCategoryListRetrieved FAILED TO PARSE HTTPDOWNLOADER REPLY");
        updateDownLoaders(pSender);
        return;
    }

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
        LOG_MESSAGE("FarmersFridgeClientPrivate::onCategoryListRetrieved FAILED TO RETRIEVE LIST OF CATEGORIES");
        return;
    }

    // Retrieve category data:
    retrieveCategoryData();

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
    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);

    // Build query:
    QString sCategorySource = QString("%1/%1.xml").arg(sCategoryName);
    QString sQuery = QString("https://%1%2").arg(m_sServerUrl).arg(sCategorySource);

    // Download:
    QDir categoryDir = m_dstDir;
    if (categoryDir.mkpath(sCategoryName))
    {
        if (categoryDir.cd(sCategoryName))
        {
            pDownLoader->download(QUrl(sQuery), categoryDir, m_sAPIKey);
        }
    }
}

// Single category data retrieved:
void FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Check reply:
    if (pSender->reply().isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved HTTPDOWNLOADER REPLY IS EMPTY");
        updateDownLoaders(pSender);
        return;
    }

    // Parse:
    CXMLNode result = CXMLNode::parseXML(pSender->reply());
    if (result.isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved FAILED TO PARSE HTTPDOWNLOADER REPLY");
        updateDownLoaders(pSender);
        return;
    }

    // Parse icons:
    foreach (CXMLNode item, result.nodes())
    {
        // Icon:
        CXMLNode iconNode = item.getNodeByTagName("icon");

        // Icon url:
        QString sIconUrl = iconNode.value();
        if (sIconUrl.simplified().isEmpty())
        {
            LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved FOUND AN EMPTY ICON URL");
            continue;
        }

        // Download single icon:
        downloadSingleIcon(sIconUrl, pSender->dstDir());
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
            LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleCategoryDataRetrieved FOUND AN EMPTY NUTRITION URL");
            continue;
        }

        QDir nutritionDir = pSender->dstDir();
        if (nutritionDir.mkpath("nutrition"))
        {
            if (nutritionDir.cd("nutrition"))
            {
                // Download single nutrition fact:
                downloadSingleNutritionFact(sNutritionUrl, nutritionDir);
            }
        }
    }

    updateDownLoaders(pSender);
}

// Download single icon:
void FarmersFridgeClientPrivate::downloadSingleIcon(const QString &sIconUrl, const QDir &dstDir)
{
    // Create HTTP downloader:
    HttpDownLoader *pDownLoaderHead = new HttpDownLoader(this);
    m_vDownloaders << pDownLoaderHead;
    connect(pDownLoaderHead, &HttpDownLoader::ready, this, &FarmersFridgeClientPrivate::onSingleIconHeadRetrieved);
    connect(pDownLoaderHead, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);
    pDownLoaderHead->download(sIconUrl, dstDir, m_sAPIKey, HttpWorker::HEAD);

    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeClientPrivate::onSingleIconRetrieved);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);
    pDownLoader->download(sIconUrl, dstDir, m_sAPIKey);
}

// Download single nutrition fact:
void FarmersFridgeClientPrivate::downloadSingleNutritionFact(const QString &sNutritionUrl, const QDir &dstDir)
{
    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    m_vDownloaders << pDownLoader;
    connect(pDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeClientPrivate::onSingleNutritionFactRetrieved);
    connect(pDownLoader, &HttpDownLoader::timeOut, this, &FarmersFridgeClientPrivate::onTimeOut);
    pDownLoader->download(sNutritionUrl, dstDir, m_sAPIKey);
}

// Single icon retrieved:
void FarmersFridgeClientPrivate::onSingleIconRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleIconRetrieved FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Check reply:
    if (pSender->reply().isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleIconRetrieved HTTPDOWNLOADER REPLY IS EMPTY");
        updateDownLoaders(pSender);
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleIconRetrieved FAILED TO DOWNLOAD: %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }
    else
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleIconRetrieved DOWNLOADED: %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single icon head retrieved:
void FarmersFridgeClientPrivate::onSingleIconHeadRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleIconRetrieved FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Check reply:
    if (pSender->reply().isEmpty())
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleIconRetrieved HTTPDOWNLOADER REPLY IS EMPTY");
        updateDownLoaders(pSender);
        return;
    }

    qDebug() << "******************* HEAD = " << pSender->reply();

    // Update downloaders:
    updateDownLoaders(pSender);
}

// Single nutrition fact retrieved:
void FarmersFridgeClientPrivate::onSingleNutritionFactRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    if (!pSender)
    {
        LOG_MESSAGE("FarmersFridgeClientPrivate::onSingleNutritionFactRetrieved FAILED TO RETRIEVE HTTPDOWNLOADER");
        return;
    }

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    if (!QFileInfo::exists(sLocalFilePath))
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleNutritionFactRetrieved FAILED TO DOWNLOAD %1 TO: %2").arg(url.toString()).arg(sLocalFilePath);
        LOG_MESSAGE(sMessage);
    }
    else
    {
        QString sMessage = QString("FarmersFridgeClientPrivate::onSingleNutritionFactRetrieved DOWNLOADED %1 TO: %2 ").arg(url.toString()).arg(sLocalFilePath);
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

    qDebug() << QString("*** WAITING FOR %1 DOWNLOADERS TO COMPLETE ***").arg(m_vDownloaders.size());
    if (m_vDownloaders.isEmpty())
        emit allDone();
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
