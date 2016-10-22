#ifndef HTTPWORKER_H
#define HTTPWORKER_H

// Application:
#include "farmers-client-global.h"

// Qt:
#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDir>
#include <QTimer>

#define TIME_OUT 120000

class FARMERSCLIENTVERSHARED_EXPORT HttpWorker : public QObject
{
    Q_OBJECT

public:
    // Request type:
    enum RequestType {GET=0, HEAD};
    Q_ENUMS(RequestType)

    // Constructor:
    HttpWorker(const QUrl &url, const QDir &dstDir, const QString &x_api_key="", const RequestType &requestType=HttpWorker::GET, QObject *parent=0);

    // Reply:
    const QByteArray &reply() const;

    // Header info:
    const QVariantMap &headerInfo() const;

    // Return local file path:
    const QString &localFilePath() const;

public slots:
    // Process:
    void process();

    // File downloaed slot:
    void onFinished(QNetworkReply* pReply);

    // Time out:
    void onTimeOut();

signals:
    // Finished signal:
    void finished();

    // Time out:
    void timeOut();

private:
    // Url:
    QUrl m_remoteUrl;

    // Destination dir:
    QDir m_dstDir;

    // x_api_key:
    QString m_x_api_key;

    // Request type:
    RequestType m_requestType;

    // Header info:
    QVariantMap m_headerInfo;

    // Downloaed data:
    QByteArray m_bReply;

    // Local file path:
    QString m_sLocalFilePath;

    // Network access manager:
    QNetworkAccessManager *m_pNetworkAccessMgr;

    // Timer:
    QTimer m_tTimer;
};

#endif // HTTPWORKER_H
