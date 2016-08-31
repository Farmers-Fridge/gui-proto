#ifndef HTTPWORKER_H
#define HTTPWORKER_H
#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDir>
#include "farmers-server_global.h"

class FARMERSSERVERSHARED_EXPORT HttpWorker : public QObject
{
    Q_OBJECT

public:
    // Request type:
    enum RequestType {GET=0, HEAD};
    Q_ENUMS(RequestType)

    // Default constructor:
    HttpWorker(QObject *parent=0);

    // Constructor:
    HttpWorker(const QUrl &url, const QDir &dstDir, const QString &x_api_key="", const RequestType &requestType=HttpWorker::GET, QObject *parent=0);

    // Set url:
    void setRemoteUrl(const QUrl &url);

    // Return url:
    const QUrl &remoteUrl() const;

    // Set dst dir:
    void setDstDir(const QDir &dir);

    // Return dst dir:
    const QDir &dstDir() const;

    // Set x_api_key:
    void set_x_api_key(const QString &x_api_key);

    // Return x_api_key:
    const QString &x_api_key() const;

    // Set request type:
    void setRequestType(const RequestType &requestType);

    // Return request type:
    const RequestType &requestType() const;

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

signals:
    // Finished signal:
    void finished();

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
};

#endif // HTTPWORKER_H
