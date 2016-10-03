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
#define SILENT false
class HttpDownLoader;

class FARMERSCLIENTVERSHARED_EXPORT FarmersFridgeClientPrivate : public QObject
{
    Q_OBJECT

public:
    // Msg type:
    enum MsgType {OK=0, ERROR, TIMEOUT};

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
    void LOG_MESSAGE(const QString &sMessage, const MsgType &msgType=OK);

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

    // Process categories:
    void processCategories(const QString &sCategoriesFile);

    // Process single category:
    void processSingleCategory(const QString &sLocalSingleCategoryFile, const QDir &dstDir);

private:
    QString m_sServerUrl;
    QString m_sAPIKey;
    QDir m_dstDir;
    QDir m_localCategoryAssetDir;
    QVector<QString> m_vCategories;
    QVector<HttpDownLoader *> m_vDownloaders;

public slots:
    // Head category list downloaded:
    void onHeadCategoryListDownloaded();

    // Category list downloaded:
    void onCategoryListDownloaded();

    // Single category data downloaded:
    void onHeadSingleCategoryDataDownloaded();

    // Single category data downloaded:
    void onSingleCategoryDataDownloaded();

    // Head single icon downloaded:
    void onHeadSingleIconDownloaded();

    // Icon downloaded:
    void onSingleIconDownloaded();

    // Head single nutrition downloaded:
    void onHeadSingleNutritionFactDownloaded();

    // Single nutrition fact downloaded:
    void onSingleNutritionFactDownloaded();

    // Time out:
    void onTimeOut();

signals:
    // All done:
    void allDone();

    // Notify:
    void message(const QString &sMessage, int msgType);
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

private:
    // Farmers Fridge client private:
    FarmersFridgeClientPrivate *m_pFarmersFridgeClientPrivate;

signals:
    // All done:
    void allDone();
};

#endif // FARMERSFRIDGECLIENT_H
