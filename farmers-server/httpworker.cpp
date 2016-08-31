#include "httpworker.h"
#include <utils.h>

// Default constructor:
HttpWorker::HttpWorker(QObject *parent) : QObject(parent),
    m_x_api_key(""),
    m_requestType(GET),
    m_sLocalFilePath(""),
    m_pNetworkAccessMgr(0)
{

}

// Constructor:
HttpWorker::HttpWorker(const QUrl &url, const QDir &dstDir, const QString &x_api_key, const RequestType &requestType, QObject *parent) : QObject(parent),
    m_remoteUrl(url),
    m_dstDir(dstDir),
    m_x_api_key(x_api_key),
    m_requestType(requestType),
    m_sLocalFilePath(""),
    m_pNetworkAccessMgr(0)
{
    m_pNetworkAccessMgr = new QNetworkAccessManager(this);
    connect(m_pNetworkAccessMgr, &QNetworkAccessManager::finished,
        this, &HttpWorker::onFinished, Qt::QueuedConnection);
    m_pNetworkAccessMgr->moveToThread(this->thread());
}

// Set url:
void HttpWorker::setRemoteUrl(const QUrl &url)
{
    m_remoteUrl = url;
}

// Return url:
const QUrl &HttpWorker::remoteUrl() const
{
    return m_remoteUrl;
}

// Set dst dir:
void HttpWorker::setDstDir(const QDir &dir)
{
    m_dstDir = dir;
}

// Return dst dir:
const QDir &HttpWorker::dstDir() const
{
    return m_dstDir;
}

// Set x_api_key:
void HttpWorker::set_x_api_key(const QString &x_api_key)
{
    m_x_api_key = x_api_key;
}

// Return x_api_key:
const QString &HttpWorker::x_api_key() const
{
    return m_x_api_key;
}

// Set request type:
void HttpWorker::setRequestType(const RequestType &requestType)
{
    m_requestType = requestType;
}

// Return request type:
const HttpWorker::RequestType &HttpWorker::requestType() const
{
    return m_requestType;
}

// Process:
void HttpWorker::process()
{
    QNetworkRequest request(m_remoteUrl);
    if (!m_x_api_key.isEmpty())
        request.setRawHeader(QString("x-api-key").toLatin1(), m_x_api_key.toLatin1());

    switch (m_requestType)
    {
        case HEAD: {
            m_pNetworkAccessMgr->head(request);
            break;
        }
        default: m_pNetworkAccessMgr->get(request);
    }
}

// File downloaded:
void HttpWorker::onFinished(QNetworkReply* pReply)
{
    if (pReply->operation() == QNetworkAccessManager::HeadOperation)
    {
        // Retrieve header info:
        QList<QNetworkReply::RawHeaderPair> headerInfo = pReply->rawHeaderPairs();
        foreach (QNetworkReply::RawHeaderPair pair, headerInfo)
            m_headerInfo[QString(pair.first)] = QString(pair.second);
    }
    else
    // Retrieve reply:
    m_bReply = pReply->readAll();

    // Build local file path:
    QString sLocalFileName = m_remoteUrl.fileName();
    m_sLocalFilePath = m_dstDir.absoluteFilePath(sLocalFileName);

    // Save:
    Utils::save(m_bReply, m_sLocalFilePath);

    // Release:
    pReply->deleteLater();

    // Notify:
    emit finished();
}

// Reply:
const QByteArray &HttpWorker::reply() const
{
    return m_bReply;
}

// Header info:
const QVariantMap &HttpWorker::headerInfo() const
{
    return m_headerInfo;
}

// Return local file path:
const QString &HttpWorker::localFilePath() const
{
    return m_sLocalFilePath;
}
