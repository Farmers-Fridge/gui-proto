#include "httpdownloader.h"
#include "httpworker.h"

// Default constructor:
HttpDownLoader::HttpDownLoader(QObject *parent) : QObject(parent),
    m_dstDir("."),
    m_sRemoteUrl(""),
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
    download(m_sRemoteUrl, m_dstDir, m_x_api_key, m_requestType);
}

// Download:
void HttpDownLoader::download(const QUrl &remoteUrl, const QDir &dstDir, const QString &x_api_key, const HttpWorker::RequestType &requestType)
{
    // Create thread:
    m_dstDir = dstDir;

    // Create workers:
    HttpWorker *pWorker = new HttpWorker(remoteUrl, m_dstDir, x_api_key, requestType);
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
QString HttpDownLoader::remoteUrl() const
{
    return m_sRemoteUrl;
}
