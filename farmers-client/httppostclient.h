#ifndef HTTPPOSTCLIENT_H
#define HTTPPOSTCLIENT_H

// Application:
#include "farmers-client-global.h"

// Qt:
#include <QObject>
class QNetworkAccessManager;
class QNetworkReply;

class FARMERSCLIENTVERSHARED_EXPORT HttpPostClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString contentType READ contentType WRITE setContentType NOTIFY contentTypeChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)

public:
    // Constructor:
    explicit HttpPostClient(QObject *parent = 0);

    // Post:
    Q_INVOKABLE void post();

private:
    // Return url:
    const QString &url() const;

    // Set url:
    void setUrl(const QString &sUrl);

    // Return content type:
    const QString &contentType() const;

    // Set content type:
    void setContentType(const QString &sContentType);

    // Return query:
    const QString &query() const;

    // Set query:
    void setQuery(const QString &sQuery);

private:
    // Url:
    QString m_sUrl;

    // Content type:
    QString m_sContentType;

    // Query:
    QString m_sQuery;

    // Network access manager:
    QNetworkAccessManager *m_pNAM;

signals:
    // Url changed:
    void urlChanged();

    // Content type changed:
    void contentTypeChanged();

    // Query changed:
    void queryChanged();

public slots:
    // Reply finished:
    void onReplyFinished(QNetworkReply *pReply);
};

#endif // HTTPPOSTCLIENT_H
