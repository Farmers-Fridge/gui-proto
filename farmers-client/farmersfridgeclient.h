#ifndef FARMERSFRIDGECLIENT_H
#define FARMERSFRIDGECLIENT_H
#include <QObject>
#include <QDir>
#include <QVector>
#include "httpworker.h"
#include "farmers-client-global.h"

#define SERVER_URL QString("xf8gcmq38b.execute-api.us-east-1.amazonaws.com/dev/v1/server/assets/")
#define X_API_KEY QString("iyiGklK5onMLiL8ag29h4atrKJJjukJ8Aq6X6id6")
#define CATEGORY_SOURCE "conf/categories.xml"
#define SERVER_DIR QString("server")
#define MD5_HEADER_KEY QString("ETag")
#define SILENT true
class HttpDownLoader;

class FARMERSCLIENTVERSHARED_EXPORT FarmersFridgeClientPrivate : public QObject
{
    Q_OBJECT

public:
    // Callback prototype:
    typedef void (FarmersFridgeClientPrivate::*CallBack)(void);

    // Constructor:
    FarmersFridgeClientPrivate(QObject *parent=0);

    // Retrieve server data:
    void retrieveServerData(
            const QString &sServerUrl,
            const QString &sAPIKey,
            const QString &sDstDir);

    // Log message:
    static void LOG_MESSAGE(const QString &sMessage);

private:
    // Retrieve category data:
    void retrieveCategoryData();

    // Retrieve single category data:
    void retrieveSingleCategoryData(const QString &sCategoryName);

    // Download single icon:
    void downloadSingleIcon(const QString &sIconUrl, const QDir &dstDir);

    // Download single nutrition fact:
    void downloadSingleNutritionFact(const QString &sNutritionUrl, const QDir &dstDir);

    // Update downloaders:
    void updateDownLoaders(HttpDownLoader *pDownloader);

    // Does asset need update?
    bool assetNeedUpdate(const QString &sAssetFullPath, const QString &sPrevMD5) const;

    // Download:
    void download(const QUrl &url, const QDir &dstDir, CallBack callBack, const HttpWorker::RequestType &requestType=HttpWorker::GET);

private:
    QString m_sServerUrl;
    QString m_sAPIKey;
    QDir m_dstDir;
    QDir m_localCategoryAssetDir;
    QVector<QString> m_vCategories;
    QVector<HttpDownLoader *> m_vDownloaders;

public slots:
    // Category list retrieved:
    void onCategoryListRetrieved();

    // Single category data retrieved:
    void onSingleCategoryDataRetrieved();

    // Icon downloaded:
    void onSingleIconRetrieved();

    // Icon head retrieved:
    void onSingleIconHeadRetrieved();

    // Single nutrition fact retrieved:
    void onSingleNutritionFactRetrieved();

    // Time out:
    void onTimeOut();

signals:
    // All done:
    void allDone();
};

class FARMERSCLIENTVERSHARED_EXPORT FarmersFridgeClient : public QObject
{
    Q_OBJECT

public:
    // Constructor:
    FarmersFridgeClient(QObject *parent=0);

    // Retrieve server data:
    void retrieveServerData(
            const QString &dstDir,
            const QString &sServerUrl=SERVER_URL,
            const QString &sAPIKey=X_API_KEY);

    // Ready:
    void onReady();

private:
    // Farmers Fridge client private:
    FarmersFridgeClientPrivate *m_pFarmersFridgeClientPrivate;

signals:
    // All done:
    void allDone();
};

#endif // FARMERSFRIDGECLIENT_H
