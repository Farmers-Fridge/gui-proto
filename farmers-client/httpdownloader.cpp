// Application:
#include "httpdownloader.h"
#include "httpworker.h"
#include <utils.h>

// Default constructor:
HttpDownLoader::HttpDownLoader(QObject *parent) : QObject(parent),
    m_dstDir("."),
    m_x_api_key(""),
    m_sLocalFilePath("")
{
}

// Destructor:
HttpDownLoader::~HttpDownLoader()
{
}

// Download:
void HttpDownLoader::download()
{
    download(m_uRemoteUrl, m_dstDir, m_x_api_key, m_requestType);
}

// Download:
void HttpDownLoader::download(const QUrl &uRemoteUrl, const QDir &dstDir, const QString &x_api_key, const HttpWorker::RequestType &requestType)
{
    // Setup downloader:
    m_dstDir = dstDir;

    // Remote url:
    m_uRemoteUrl = uRemoteUrl;

    // Create workers:
    HttpWorker *pWorker = new HttpWorker(uRemoteUrl, m_dstDir, x_api_key, requestType);
    connect(pWorker, &HttpWorker::finished, this, &HttpDownLoader::onFinished);
    connect(pWorker, &HttpWorker::timeOut, this, &HttpDownLoader::timeOut);

    // Start thread:
    pWorker->process();
}

// Data downloaded:
void HttpDownLoader::onFinished()
{
    // Get src worker:
    HttpWorker *pWorker = dynamic_cast<HttpWorker *>(sender());
    if (!pWorker)
        return;

    // Get reply:
    m_bReply = pWorker->reply();

    // Set header info:
    m_mHeaderInfo = pWorker->headerInfo();

    // Set local file path:
    setLocalFilePath(pWorker->localFilePath());

    // Release worker:
    delete pWorker;

    // Notify:
    emit ready();
}

// Return dst dir:
const QDir &HttpDownLoader::dstDir() const
{
    return m_dstDir;
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
}

// Return header info:
const QVariantMap &HttpDownLoader::headerInfo() const
{
    return m_mHeaderInfo;
}

// Return reply:
const QByteArray &HttpDownLoader::reply() const
{
    return m_bReply;
}

// Return url:
const QUrl &HttpDownLoader::remoteUrl() const
{
    return m_uRemoteUrl;
}

// Get header info:
QString HttpDownLoader::getHeaderInfo(const QString &sKey) const
{
    return Utils::clearString(m_mHeaderInfo[sKey].toString());
}
