#include "httpworker.h"
#include <utils.h>

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
    m_tTimer.setSingleShot(true);
    connect(&m_tTimer, &QTimer::timeout, this, &HttpWorker::onTimeOut);
}

// Process:
void HttpWorker::process()
{
    // Start timer:
    m_tTimer.start(TIME_OUT);

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
    // Stop timer:
    m_tTimer.stop();
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
    delete pReply;

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

// Time out:
void HttpWorker::onTimeOut()
{
    delete m_pNetworkAccessMgr;
    emit timeOut();
}
