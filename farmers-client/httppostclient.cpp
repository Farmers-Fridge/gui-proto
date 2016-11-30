// Application:
#include "httppostclient.h"

// Qt:
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QNetworkReply>

// Constructor:
HttpPostClient::HttpPostClient(QObject *parent) : QObject(parent),
    m_sUrl("127.0.0.1"), m_sContentType("application/json"),
    m_sQuery(""), m_pNAM(NULL)
{
    m_pNAM = new QNetworkAccessManager(this);
    connect(m_pNAM, &QNetworkAccessManager::finished,
        this, &HttpPostClient::onReplyFinished);
}

// Return url:
const QString &HttpPostClient::url() const
{
    return m_sUrl;
}

// Set url:
void HttpPostClient::setUrl(const QString &sUrl)
{
    m_sUrl = sUrl;
    emit urlChanged();
}

// Return content type:
const QString &HttpPostClient::contentType() const
{
    return m_sContentType;
}

// Set content type:
void HttpPostClient::setContentType(const QString &sContentType)
{
    m_sContentType = sContentType;
    emit contentTypeChanged();
}

// Return query:
const QString &HttpPostClient::query() const
{
    return m_sQuery;
}

// Set query:
void HttpPostClient::setQuery(const QString &sQuery)
{
    m_sQuery = sQuery;
    emit queryChanged();
}

// Post:
void HttpPostClient::post()
{
    // Build url object:
    QUrl url(m_sUrl);

    // Build network request:
    QNetworkRequest request(url);

    // Set header:
    request.setHeader(QNetworkRequest::ContentTypeHeader, m_sContentType);

    QByteArray data = m_sQuery.simplified().toLatin1();
    qDebug() << "data = " << QString::fromUtf8(data.data(), data.size());
    m_pNAM->post(request, data);
}

// Reply finished:
void HttpPostClient::onReplyFinished(QNetworkReply *pReply)
{
    qDebug() << "ICI: " << pReply->readAll();
}
