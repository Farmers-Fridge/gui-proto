#include "farmersfridgeserver.h"
#include "httpworker.h"
#include "cxmlnode.h"
#include <QMap>
#include <QThread>
#include <QFileInfo>
#include "utils.h"
#include "constants.h"

int HttpDownLoader::nCreated = 0;
int HttpDownLoader::nDestroyed = 0;

// Default constructor:
HttpDownLoader::HttpDownLoader(QObject *parent) : QObject(parent),
    m_dstDir("."),
    m_sRemoteUrl(""),
    m_x_api_key(""),
    m_sLocalFilePath(""),
    m_pServer(0)
{
    nCreated++;
}

// Constructor:
HttpDownLoader::HttpDownLoader(FarmersFridgeServer *pServer, QObject *parent) : QObject(parent),
    m_dstDir("."),
    m_sRemoteUrl(""),
    m_x_api_key(""),
    m_pServer(pServer)
{
    nCreated++;
}

// Destructor:
HttpDownLoader::~HttpDownLoader()
{
    nDestroyed++;
    if (m_pServer)
    {
        if (nDestroyed == nCreated)
            m_pServer->onAllDownLoadComplete();
    }
}

// Download:
void HttpDownLoader::download()
{
    download(m_sRemoteUrl, m_dstDir, m_x_api_key, m_requestType);
}

// Download:
void HttpDownLoader::download(const QUrl &remoteUrl, const QDir &dstDir, const QString &x_api_key, const HttpWorker::RequestType &requestType)
{
    // Create thread:
    QThread *pThread = new QThread;

    // Create workers:
    HttpWorker *pWorker = new HttpWorker(remoteUrl, dstDir, x_api_key, requestType);
    pWorker->setDstDir(dstDir);
    pWorker->moveToThread(pThread);

    connect(pThread, &QThread::started, pWorker, &HttpWorker::process);
    connect(pWorker, &HttpWorker::finished, this, &HttpDownLoader::onFinished);
    connect(pWorker, &HttpWorker::finished, pThread, &QThread::quit);
    connect(pThread, &QThread::finished, pWorker, &HttpWorker::deleteLater);
    connect(pThread, &QThread::finished, pThread, &QThread::deleteLater);

    // Start thread:
    pThread->start();
}

// Data downloaded:
void HttpDownLoader::onFinished()
{
    // Get src worker:
    HttpWorker *pWorker = dynamic_cast<HttpWorker *>(sender());
    if (!pWorker)
        return;

    // Get reply:
    QByteArray reply = pWorker->reply();
    if (reply.isEmpty() || reply.isNull())
    {
        emit error();
        pWorker->deleteLater();
        return;
    }

    // Set header info:
    setHeaderInfo(pWorker->headerInfo());

    // Set local file path:
    setLocalFilePath(pWorker->localFilePath());

    // Set remote url:
    setRemoteUrl(pWorker->remoteUrl().toString());

    // Release worker:
    pWorker->deleteLater();

    // Notify:
    emit ready();
}

// Return dst dir:
QString HttpDownLoader::dstDir() const
{
    return m_dstDir;
}

// Set dst dir:
void HttpDownLoader::setDstDir(const QString &dstDir)
{
    m_dstDir = dstDir;
    emit dstDirChanged();
}

// Return x_api_key:
QString HttpDownLoader::x_api_key() const
{
    return m_x_api_key;
}

// Set x_api_key:
void HttpDownLoader::set_x_api_key(const QString &x_api_key)
{
    m_x_api_key = x_api_key;
    emit x_api_key_changed();
}

// Return request type:
int HttpDownLoader::requestType() const
{
    return m_requestType;
}

// Set request type:
void HttpDownLoader::setRequestType(int requestType)
{
    m_requestType = (HttpWorker::RequestType)requestType;
    emit requestTypeChanged();
}

// Return local file path:
const QString &HttpDownLoader::localFilePath() const
{
    return m_sLocalFilePath;
}

// Set local file path:
void HttpDownLoader::setLocalFilePath(const QString &sLocalFilePath)
{
    m_sLocalFilePath = sLocalFilePath;
    emit localFilePathChanged();
}

// Return header info:
const QVariant &HttpDownLoader::headerInfo() const
{
    return m_vHeaderInfo;
}

// Set header info:
void HttpDownLoader::setHeaderInfo(const QVariant &vHeaderInfo)
{
    m_vHeaderInfo = vHeaderInfo;
    emit headerInfoChanged();
}

// Return url:
QString HttpDownLoader::remoteUrl() const
{
    return m_sRemoteUrl;
}

// Set x_api_key:
void HttpDownLoader::setRemoteUrl(const QString &sUrl)
{
    m_sRemoteUrl = sUrl;
    emit remoteUrlChanged();
}

// Default constructor:
FarmersFridgeServer::FarmersFridgeServer(QObject *parent) : QObject(parent)
{

}

// Destructor:
FarmersFridgeServer::~FarmersFridgeServer()
{

}

// Set attributes:
void FarmersFridgeServer::setAttributes(const QMap<QString, QString> &mAttributes)
{
    m_mAttributes = mAttributes;
}

// Create local icon dir:
void FarmersFridgeServer::createLocalIconDir()
{
    m_localCategoryIconDir = Utils::appDir();
    m_localCategoryIconDir.cdUp();
    m_localCategoryIconDir.mkpath(LOCAL_CATEGORY_ICON_DIR);
    m_localCategoryIconDir.cd(LOCAL_CATEGORY_ICON_DIR);
}

// Create local header dir:
void FarmersFridgeServer::createLocalHeaderDir()
{
    m_localCategoryHeaderDir = Utils::appDir();
    m_localCategoryHeaderDir.cdUp();
    m_localCategoryHeaderDir.mkpath(LOCAL_CATEGORY_HEADER_DIR);
    m_localCategoryHeaderDir.cd(LOCAL_CATEGORY_HEADER_DIR);
}

// Create local asset dir:
void FarmersFridgeServer::createLocalAssetDir()
{
    m_localAssetDir = Utils::appDir();
    m_localAssetDir.cdUp();
    m_localAssetDir.mkpath(LOCAL_ASSET_DIR);
    m_localAssetDir.cd(LOCAL_ASSET_DIR);
}

// Return local assets dir:
QString FarmersFridgeServer::localAssetDir() const
{
    return m_localAssetDir.absolutePath();
}

// Return local XML dir:
QString FarmersFridgeServer::localXMLDir() const
{
    return m_localXMLDir.absolutePath();
}

// Create local XML dir:
void FarmersFridgeServer::createLocalXMLDir()
{
    m_localXMLDir = Utils::appDir();
    m_localXMLDir.cdUp();
    m_localXMLDir.mkpath(LOCAL_XML_DIR);
    m_localXMLDir.cd(LOCAL_XML_DIR);
}

// Retrieve server data:
void FarmersFridgeServer::retrieveServerData()
{
    // Create local directories:
    createLocalDirectories();

    // Build query:
    QString sCurrentIp = m_mAttributes[CURRENT_IP];
    QString sPortNumber = m_mAttributes[PORT_NUMBER];
    QString sCategorySource = m_mAttributes[CATEGORY_SOURCE];
    QString sQuery = QString("http://%1:%2%3").arg(sCurrentIp).arg(sPortNumber).arg(sCategorySource);

    // Create HTTP downloader:
    HttpDownLoader *pDownLoader = new HttpDownLoader(this);
    connect(pDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onCategoryListRetrieved);

    // Download:
    pDownLoader->download(QUrl(sQuery), m_localXMLDir);
}

// All download complete:
void FarmersFridgeServer::onAllDownLoadComplete()
{
    emit allDownLoadComplete();
}

// Category icon downloaded:
void FarmersFridgeServer::onCategoryIconDownLoaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());

    // Retrieve source url:
    QUrl remoteUrl = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    // Release:
    delete pSender;

    qDebug() << "DOWNLOADED: " << remoteUrl.toString() << " TO: " << sLocalFilePath;
}

// Category header downloaded:
void FarmersFridgeServer::onCategoryHeaderDownLoaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());

    // Retrieve remote url:
    QUrl remoteUrl = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    // Release:
    delete pSender;

    qDebug() << "DOWNLOADED: " << remoteUrl.toString() << " TO: " << sLocalFilePath;
}

// Dish image downloaded:
void FarmersFridgeServer::onDishImageDownLoaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());

    // Retrieve remote url:
    QUrl url = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    // Release:
    delete pSender;

    qDebug() << "DOWNLOADED: " << url.toString() << " TO: " << sLocalFilePath;
}

// Dish nutrition downloaded:
void FarmersFridgeServer::onDishNutritionDownLoaded()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());

    // Retrieve remote url:
    QUrl remoteUrl = pSender->remoteUrl();

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    // Release:
    delete pSender;

    qDebug() << "DOWNLOADED: " << remoteUrl.toString() << " TO: " << sLocalFilePath;
}

// Category list retrieved:
void FarmersFridgeServer::onCategoryListRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());

    // Retrieve local file path:
    QString sLocalFilePath = pSender->localFilePath();

    // Check downloaded file:
    QFileInfo fi(sLocalFilePath);
    if (!fi.exists())
    {
        delete pSender;
        return;
    }

    // Retrieve category data:
    QString sCurrentIp = m_mAttributes[CURRENT_IP];
    QString sPortNumber = m_mAttributes[PORT_NUMBER];
    QString sCategoryListSource = m_mAttributes[CATEGORY_LIST_SOURCE];
    QString sUrlPublicRootValue = m_mAttributes[URL_PUBLIC_ROOT_VALUE];
    QString sRootPath = "https://" + sUrlPublicRootValue + "%1";

    // Parse category names and icon names:
    CXMLNode result = CXMLNode::loadXMLFromFile(sLocalFilePath);
    if (result.isEmpty())
    {
        delete pSender;
        return;
    }

    QString sQuery = "";
    QString sDstDir = "";
    foreach (CXMLNode item, result.nodes())
    {
        /********** Categories **********/

        // Category name:
        CXMLNode categoryNode = item.getNodeByTagName("categoryName");
        QString sCategoryName = categoryNode.value();
        if (sCategoryName.simplified().isEmpty())
            continue;

        // Build query for retrieving category data:
        sQuery = QString("http://%1:%2%3?category=%4").arg(sCurrentIp).arg(sPortNumber).arg(sCategoryListSource).arg(sCategoryName);

        // Create HTTP downloader:
        HttpDownLoader *pCategoryDownLoader = new HttpDownLoader(this);
        connect(pCategoryDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onCategoryDataRetrieved);

        // Download:
        if (m_localXMLDir.mkpath(sCategoryName))
            pCategoryDownLoader->download(QUrl(sQuery), m_localXMLDir.absoluteFilePath(sCategoryName));

        /********** Icons **********/

        // Icon:
        CXMLNode iconNode = item.getNodeByTagName("icon");
        QString sIconName = iconNode.value();

        if (!sIconName.simplified().isEmpty())
        {
            // Retrieve icon path:
            sQuery = sRootPath.arg(sIconName);

            // Download:
            HttpDownLoader *pIconDownLoader = new HttpDownLoader(this);
            connect(pIconDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onCategoryIconDownLoaded);

            // Build dst dir:
            sDstDir = buildDstDir(sIconName);

            // Download:
            if (!sDstDir.isEmpty())
            {
                if (m_localCategoryIconDir.mkpath(sDstDir))
                {
                    // Update XML:
                    QUrl url(sQuery);
                    QDir dstDir(m_localCategoryIconDir.absoluteFilePath(sDstDir));

                    // Download:
                    pIconDownLoader->download(url, dstDir);
                }
            }
        }

        /********** Headers **********/

        // Header:
        CXMLNode headerNode = item.getNodeByTagName("header");
        QString sHeaderName = headerNode.value();

        if (!sHeaderName.simplified().isEmpty())
        {
            // Retrieve icon path:
            sQuery = sRootPath.arg(sHeaderName);

            // Download:
            HttpDownLoader *pHeaderDownLoader = new HttpDownLoader(this);
            connect(pHeaderDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onCategoryHeaderDownLoaded);

            // Build dst dir:
            sDstDir = buildDstDir(sHeaderName);

            // Download:
            if (!sDstDir.isEmpty())
            {
                if (m_localCategoryHeaderDir.mkpath(sDstDir))
                {
                    // Update XML:
                    QUrl url(sQuery);
                    QDir dstDir(m_localCategoryHeaderDir.absoluteFilePath(sDstDir));

                    // Download:
                    pHeaderDownLoader->download(url, dstDir);
                }
            }
        }
    }

    // Save XML:
    result.saveXMLToFile(sLocalFilePath);

    delete pSender;
}

// Build dst dir:
QString FarmersFridgeServer::buildDstDir(const QString &imgPath)
{
    if (imgPath.simplified().isEmpty())
        return "";
    QString tmp = imgPath;
    if (tmp.startsWith("/"))
        tmp.remove(0, 1);
    QStringList splitted = tmp.split("/");
    splitted.removeLast();
    return splitted.join("/");
}

// Category data retrieved:
void FarmersFridgeServer::onCategoryDataRetrieved()
{
    // Retrieve sender:
    HttpDownLoader *pSender = dynamic_cast<HttpDownLoader *>(sender());
    QString sLocalFilePath = pSender->localFilePath();

    // Check downloaded data:
    QFileInfo fi(sLocalFilePath);
    if (!fi.exists())
    {
        delete pSender;
        return;
    }

    // Parse category names:
    CXMLNode result = CXMLNode::loadXMLFromFile(sLocalFilePath);
    QString sUrlPublicRootValue = m_mAttributes[URL_PUBLIC_ROOT_VALUE];
    QString sRootPath = "https://" + sUrlPublicRootValue + "%1";
    QString sQuery = "";
    foreach (CXMLNode item, result.nodes())
    {
        //
        // Retrieve icon path:
        //

        CXMLNode iconNode = item.getNodeByTagName("icon");
        QString sIconPath = iconNode.value();

        if (!sIconPath.simplified().isEmpty())
        {
            sQuery = sRootPath.arg(sIconPath);

            // Create HTTP downloader:
            HttpDownLoader *pIconDownLoader = new HttpDownLoader(this);
            connect(pIconDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onDishImageDownLoaded);

            // Create destination directory:
            QString sIconDstDir = buildDstDir(sIconPath);

            // Download:
            if (!sIconDstDir.isEmpty())
            {
                if (m_localAssetDir.mkpath(sIconDstDir))
                {
                    // Update XML:
                    QUrl url(sQuery);
                    QDir dstDir(m_localAssetDir.absoluteFilePath(sIconDstDir));

                    // Download:
                    pIconDownLoader->download(url, dstDir);
                }
            }
        }

        //
        // Retrieve nutrition fact:
        //

        CXMLNode nutritionNode = item.getNodeByTagName("nutrition");
        QString sNutritionPath = nutritionNode.value();

        if (!sNutritionPath.simplified().isEmpty())
        {
            sQuery = sRootPath.arg(sNutritionPath);

            // Create HTTP downloader:
            HttpDownLoader *pNutritionDownLoader = new HttpDownLoader(this);
            connect(pNutritionDownLoader, &HttpDownLoader::ready, this, &FarmersFridgeServer::onDishNutritionDownLoaded);

            // Create destination directory:
            QString sNutritionDstDir = buildDstDir(sNutritionPath);

            // Download:
            if (!sNutritionDstDir.isEmpty())
            {
                if (m_localAssetDir.mkpath(sNutritionDstDir))
                {
                    // Update XML:
                    QUrl url(sQuery);
                    QDir dstDir(m_localAssetDir.absoluteFilePath(sNutritionDstDir));

                    // Download:
                    pNutritionDownLoader->download(url, dstDir);
                }
            }
        }
    }

    // Save XML:
    result.saveXMLToFile(sLocalFilePath);

    delete pSender;
}

// Remove server dir:
void FarmersFridgeServer::removeServerDir()
{
    Utils::clearDirectory(m_localServerDir.absolutePath());
}

// Define local directories:
void FarmersFridgeServer::defineLocalDirectories()
{
    // Server dir:
    m_localServerDir = Utils::appDir();
    m_localServerDir.cdUp();
    m_localServerDir = m_localServerDir.absoluteFilePath(LOCAL_SERVER_DIR);

    // Local category icon dir:
    m_localCategoryIconDir = Utils::appDir();
    m_localCategoryIconDir.cdUp();
    m_localCategoryIconDir = m_localCategoryIconDir.absoluteFilePath(LOCAL_CATEGORY_ICON_DIR);

    // Local category header dir:
    m_localCategoryHeaderDir = Utils::appDir();
    m_localCategoryHeaderDir.cdUp();
    m_localCategoryHeaderDir = m_localCategoryHeaderDir.absoluteFilePath(LOCAL_CATEGORY_HEADER_DIR);

    // Local asset dir:
    m_localAssetDir = Utils::appDir();
    m_localAssetDir.cdUp();
    m_localAssetDir = m_localAssetDir.absoluteFilePath(LOCAL_ASSET_DIR);

    // Local XML dir:
    m_localXMLDir = Utils::appDir();
    m_localXMLDir.cdUp();
    m_localXMLDir = m_localXMLDir.absoluteFilePath(LOCAL_XML_DIR);
}

// Clear local directories:
void FarmersFridgeServer::createLocalDirectories()
{
    // Create local icon dir:
    createLocalIconDir();

    // Create local header dir:
    createLocalHeaderDir();

    // Create local asset dir:
    createLocalAssetDir();

    // Create local XML dir:
    createLocalXMLDir();
}
