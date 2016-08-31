#ifndef FARMERSFRIDGESERVER_H
#define FARMERSFRIDGESERVER_H
#include <QObject>
#include <QDir>
#include "httpworker.h"
#include "farmers-server_global.h"
#include <csingleton.h>
class FarmersFridgeServer;

class FARMERSSERVERSHARED_EXPORT HttpDownLoader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString dstDir READ dstDir WRITE setDstDir NOTIFY dstDirChanged)
    Q_PROPERTY(QString remoteUrl READ remoteUrl WRITE setRemoteUrl NOTIFY remoteUrlChanged)
    Q_PROPERTY(QString x_api_key READ x_api_key WRITE set_x_api_key NOTIFY x_api_key_changed)
    Q_PROPERTY(int requestType READ requestType WRITE setRequestType NOTIFY requestTypeChanged)
    Q_PROPERTY(QString localFilePath READ localFilePath NOTIFY localFilePathChanged)
    Q_PROPERTY(QVariant headerInfo READ headerInfo WRITE setHeaderInfo NOTIFY headerInfoChanged)

public:
    friend class FarmersFridgeServer;

    // Destructor:
    ~HttpDownLoader();

    // Download:
    Q_INVOKABLE void download();

    // Download:
    void download(const QUrl &remoteUrl, const QDir &dstDir, const QString &x_api_key="", const HttpWorker::RequestType &requestType=HttpWorker::GET);

    // Return dst dir:
    QString dstDir() const;

    // Set dst dir:
    void setDstDir(const QString &dstDir);

    // Return url:
    QString remoteUrl() const;

    // Set url:
    void setRemoteUrl(const QString &url);

    // Return x_api_key:
    QString x_api_key() const;

    // Set x_api_key:
    void set_x_api_key(const QString &x_api_key);

    // Return request type:
    int requestType() const;

    // Set request type:
    void setRequestType(int requestType);

    // Return local file path:
    const QString &localFilePath() const;

    // Set local file path:
    void setLocalFilePath(const QString &sLocalFilePath);

    // Return header info:
    const QVariant &headerInfo() const;

    // Set header info:
    void setHeaderInfo(const QVariant &headerInfo);

protected:
    // Default constructor:
    HttpDownLoader(QObject *parent=0);

    // Constructor:
    HttpDownLoader(FarmersFridgeServer *pServer, QObject *parent=0);

private:
    // Interface:
    QString m_dstDir;
    QString m_sRemoteUrl;
    QString m_x_api_key;
    QString m_sLocalFilePath;
    QVariant m_vHeaderInfo;
    HttpWorker::RequestType m_requestType;

    // Internal:
    static int nCreated;
    static int nDestroyed;
    FarmersFridgeServer *m_pServer;

public slots:
    // Data downloaded:
    void onFinished();

signals:
    // Data ready:
    void ready();

    // Data error:
    void error();

    // Dst dir changed:
    void dstDirChanged();

    // URL changed:
    void remoteUrlChanged();

    // x_api_key changed:
    void x_api_key_changed();

    // Request type changed:
    void requestTypeChanged();

    // Local file path changed:
    void localFilePathChanged();

    // Header info changed:
    void headerInfoChanged();
};

class FARMERSSERVERSHARED_EXPORT FarmersFridgeServer : public QObject,
    public CSingleton<FarmersFridgeServer>
{
    Q_OBJECT

public:
    // Default constructor:
    explicit FarmersFridgeServer(QObject *parent=0);

    // Destructor:
    virtual ~FarmersFridgeServer();

    // Set attributes:
    void setAttributes(const QMap<QString, QString> &mAttributes);

    // Retrieve server data:
    void retrieveServerData();

    // All download complete:
    void onAllDownLoadComplete();

    // Return local assets dir:
    QString localAssetDir() const;

    // Return local XML dir:
    QString localXMLDir() const;

    // Define local directories:
    void defineLocalDirectories();

    // Clear local directories:
    void createLocalDirectories();

    // Remove server dir:
    void removeServerDir();

    // Build dst dir:
    static QString buildDstDir(const QString &imgPath);

public slots:
    // Category list retrieved:
    void onCategoryListRetrieved();

    // Category data retrieved:
    void onCategoryDataRetrieved();

    // Category icon downloaded:
    void onCategoryIconDownLoaded();

    // Category header downloaded:
    void onCategoryHeaderDownLoaded();

    // Dish image downloaded:
    void onDishImageDownLoaded();

    // Dish nutrition downloaded:
    void onDishNutritionDownLoaded();

private:
    // Create local icon dir:
    void createLocalIconDir();

    // Create local header dir:
    void createLocalHeaderDir();

    // Create local asset dir:
    void createLocalAssetDir();

    // Create local XML dir:
    void createLocalXMLDir();

    // Load application parameters:
    void loadApplicationParameters();

private:
    // Dish image server private:
    HttpDownLoader *m_pHttpDownLoader;

    // Category worker:
    HttpWorker *m_pHttpWorker;

    // Local server dir:
    QDir m_localServerDir;

    // Local category icon dir:
    QDir m_localCategoryIconDir;

    // Local category header dir:
    QDir m_localCategoryHeaderDir;

    // Local asset dir:
    QDir m_localAssetDir;

    // Local XML dir:
    QDir m_localXMLDir;

    // Attributes:
    QMap<QString, QString> m_mAttributes;

signals:
    // All download complete:
    void allDownLoadComplete();
};

#endif // FARMERSFRIDGESERVER_H
