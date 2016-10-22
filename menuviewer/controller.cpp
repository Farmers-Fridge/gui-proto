// Application:
#include "controller.h"
#include "utils.h"
#include <farmersfridgeclient.h>
#include "eventwatcher.h"
#include "cartmodel.h"
#include "tablemodel.h"
#include "colormodel.h"
#include "messagemodel.h"
#include "layoutmanager.h"
#include "documenthandler.h"

// Qt:
#include <QQmlContext>
#include <QSettings>
#include <QDebug>

// Constructor:
Controller::Controller(QObject *parent) : QObject(parent),
    mFarmersClient(0), mEventWatcher(0), mCartModel(0), mTableModel(0),
    mColorModel(0), mMessageModel(0), mCurrentCategory(""), mCurrentFilter(""),
    mCurrentNetworkIP("127.0.0.1"), mOffLinePath(""), mServerDataRetrieved(false)
{
    // Client:
    mFarmersClient = new FarmersFridgeClient(this);
    connect(mFarmersClient, &FarmersFridgeClient::allDone, this, &Controller::onDataReady);

    // Cart model:
    mCartModel = new CartModel(this);

    // Event watcher:
    mEventWatcher = new EventWatcher(this);

    // Table model:
    mTableModel = new TableModel(this);

    // Color model:
    mColorModel = new ColorModel(this);
    mColorModel->initialize();
    connect(mColorModel, &ColorModel::updateColors, this, &Controller::onUpdateColors);

    // Layout manager:
    mLayoutManager = new LayoutManager(this);
    mLayoutManager->initialize();

    // Message model:
    mMessageModel = new MessageModel(this);

    // Install event filter:
    QCoreApplication::instance()->installEventFilter(mEventWatcher);
}

// Destructor:
Controller::~Controller()
{
}

// Data ready:
void Controller::onDataReady()
{
    // Server data retrieved:
    setServerDataRetrieved(true);

    // Set download report:
    setDownloadReport();
}

// Startup:
bool Controller::startup()
{
    QDir appDir = Utils::appDir();
    if (appDir.cdUp())
        mFarmersClient->retrieveServerData();

    // Define offline path:
    QDir offLinePath = Utils::appDir();
    if (offLinePath.cdUp())
        mOffLinePath = offLinePath.absoluteFilePath(SERVER_DIR);

    // Read salad assets:
    readSaladAssets();

    // Register types:
    registerTypes();

    // Set context properties:
    setContextProperties();

    // Start GUI:
    startGUI();

    return true;
}

// Shutdown:
void Controller::shutdown()
{
}

// Return salad assets:
const QStringList &Controller::saladAssets() const
{
    return mSaladAssets;
}

// Register types:
void Controller::registerTypes()
{
    qmlRegisterType<DocumentHandler>("Components", 1, 0, "DocumentHandler");
    qmlRegisterType<MessageModel>("Components", 1, 0, "MessageModel");
}

// Set context properties:
void Controller::setContextProperties()
{
    mEngine.rootContext()->setContextProperty("_controller", this);
    mEngine.rootContext()->setContextProperty("_eventWatcher", mEventWatcher);
    mEngine.rootContext()->setContextProperty("_cartModel", mCartModel);
    mEngine.rootContext()->setContextProperty("_tableModel", mTableModel);
    mEngine.rootContext()->setContextProperty("_colorModel", mColorModel);
    mEngine.rootContext()->setContextProperty("_messageModel", mMessageModel);
    mEngine.rootContext()->setContextProperty("_colors", mColorModel->colors());
    mEngine.rootContext()->setContextProperty("_farmersClient", mFarmersClient);
    mEngine.rootContext()->setContextProperty("_layoutMgr", mLayoutManager);
}

// Start GUI:
void Controller::startGUI()
{
    // Find qml lib dir:
    QDir qmlLibDir = Utils::appDir();

    // Load farmers-common:
    if (qmlLibDir.cdUp())
        if (qmlLibDir.cd("FarmersCommon"))
            mEngine.addImportPath(qmlLibDir.absolutePath());

    // Load:
    mEngine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

// Read asset salads:
void Controller::readSaladAssets()
{
    QDir idleImagesDir = Utils::appDir();
    if (idleImagesDir.cdUp())
    {
        if (idleImagesDir.cd("idle_images"))
        {
            QStringList filter;
            filter << "*.png";
            Utils::files(idleImagesDir.absolutePath(), filter, mSaladAssets);
            emit saladAssetsChanged();
        }
    }
}

// Return current network IP:
const QString &Controller::currentNetworkIP() const
{
    return mCurrentNetworkIP;
}

// Set current network IP:
void Controller::setCurrentNetworkIP(const QString &currentNetworkIP)
{
    mCurrentNetworkIP = currentNetworkIP;
    emit currentNetworkIPChanged();
}

// Return cart model:
QObject *Controller::cartModel() const
{
    return mCartModel;
}

// Return current category:
const QString &Controller::currentCategory() const
{
    return mCurrentCategory;
}

// Set current category:
void Controller::setCurrentCategory(const QString &categoryName)
{
    mCurrentCategory = categoryName;
    emit currentCategoryChanged();
}

// Return current filter:
const QString &Controller::currentFilter() const
{
    return mCurrentFilter;
}

// Set current filter:
void Controller::setCurrentFilter(const QString &filterName)
{
    mCurrentFilter = filterName;
    emit currentFilterChanged();
}

// Set item count:
void Controller::setItemCount(int count, const QString &vendItemName)
{
    mCartModel->setItemCount(count, vendItemName);
}

// Add item:
void Controller::addItem(const QString &vendItemName, const QString &icon,
                         const QString &nutrition, const QString &category, const QString &price)
{
    mCartModel->addItem(vendItemName, icon, nutrition, category, price);
}

// Remove item:
void Controller::removeItem(const QString &vendItemName)
{
    mCartModel->removeItem(vendItemName);
}

// Clear cart:
void Controller::clearCart()
{
    mCartModel->clear();
}

// Validate email address:
bool Controller::validateEmailAddress(const QString &emailAddress)
{
    return Utils::validateEmailAddress(emailAddress);
}

// Validate coupon:
bool Controller::validateCoupon(const QString &coupon)
{
    Q_UNUSED(coupon);
    return true;
}

// To local file:
QString Controller::toLocalFile(const QString &filePath)
{
    return Utils::toLocalFile(filePath);
}

// From local file:
QString Controller::fromLocalFile(const QString &filePath)
{
    return Utils::fromLocalFile(filePath);
}

// Return offline path:
const QString &Controller::offLinePath() const
{
    return mOffLinePath;
}

// Set current menu item for category:
void Controller::setCurrentMenuItemForCategory(const QVariant &menuItem)
{
    QVariantMap expanded = menuItem.toMap();
    if (expanded.isEmpty())
        return;
    QString category = expanded["category"].toString();
    if (category.simplified().isEmpty())
        return;
    mCurrentItemForCategory[category] = menuItem;

    emit currentMenuItemForCategoryChanged();
}

// Retur current menu item for category:
QVariant Controller::getCurrentMenuItemForCategory(const QString &category)
{
    return mCurrentItemForCategory[category];
}

// Update colors:
void Controller::onUpdateColors()
{
    mEngine.rootContext()->setContextProperty("_colors", mColorModel->colors());
}

// Restore default settings for colors:
void Controller::restoreDefaultSettingsForColors()
{
    mColorModel->useHardCodedSettings();
}

// Save color settings:
void Controller::saveColorSettings()
{
    // Load current:
    QString settingsFile = Utils::pathToSettingsFile("colors.xml");

    // Add new Colors node:
    CXMLNode colorsNode("Colors");

    // Add individual colors:
    QVariantMap newColors = mColorModel->colors().toMap();
    for (QVariantMap::iterator it=newColors.begin(); it!=newColors.end(); ++it)
    {
        CXMLNode colorNode("Color");
        colorNode.setAttribute(QString("name"), it.key());
        colorNode.setAttribute(QString("value"), it.value().toString());
        colorsNode.addNode(colorNode);
    }

    // Save:
    colorsNode.save(settingsFile);
}

// Restore default settings for layouts:
void Controller::restoreDefaultSettingsForLayouts()
{
    mLayoutManager->defineDefaultLayouts();
}

// Save layout settings:
void Controller::saveLayoutSettings()
{
    // Load current:
    QString settingsFile = Utils::pathToSettingsFile("layouts.xml");

    // Add new Colors node:
    CXMLNode layoutsNode("Layouts");

    // Add individual colors:
    QList<Layout> layouts = mLayoutManager->layouts();

    foreach (Layout layout, layouts)
    {
        CXMLNode layoutNode("Layout");
        layoutNode.setAttribute("nCols", QString::number(layout.nCols));
        layoutNode.setAttribute("nRows", QString::number(layout.nRows));
        QList<bool> lLayoutValues = layout.values();
        QStringList lLayout;
        for (int i=0; i<lLayoutValues.size(); i++)
            lLayout << (lLayoutValues[i] ? "true" : "false");
        layoutNode.setAttribute(QString("value"), lLayout.join(","));
        layoutsNode.addNode(layoutNode);
    }

    // Save:
    layoutsNode.save(settingsFile);
}

// Save settings:
void Controller::saveSettings()
{
    // Save color settings:
    saveColorSettings();

    // Save layout settings:
    saveLayoutSettings();
}

// Return file base name:
QString Controller::fileBaseName(const QString &sFullPath) const
{
    QFileInfo fi(sFullPath);
    return fi.fileName();
}

// Set download report:
void Controller::setDownloadReport()
{
    mMessageModel->setMessages(mFarmersClient->messages());
}

// Server data retrieved:
bool Controller::serverDataRetrieved() const
{
    return mServerDataRetrieved;
}

// Set server data retrieved:
void Controller::setServerDataRetrieved(bool retrieved)
{
    mServerDataRetrieved = retrieved;
    emit serverDataRetrievedChanged();
}
