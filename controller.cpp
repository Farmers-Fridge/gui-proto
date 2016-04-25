#include "controller.h"
#include "utils.h"
#include "eventwatcher.h"
#include "cartmodel.h"
#include "documenthandler.h"
#include <QQmlContext>
#include <QSettings>
#include <QDebug>

// Constructor:
Controller::Controller(QObject *parent) : QObject(parent),
    mEventWatcher(0), mCartModel(0), mCurrentCategory(""),
    mCurrentFilter(""), mCurrentNetworkIP("127.0.0.1")
{
    // Cart model:
    mCartModel = new CartModel(this);

    // Event watcher:
    mEventWatcher = new EventWatcher(this);
}

// Destructor:
Controller::~Controller()
{
}

// Startup:
bool Controller::startup()
{
    // Read salad assets:
    readSaladAssets();

    // Register types:
    registerTypes();

    // Set context properties:
    setContextProperties();

    // Start GUI:
    startGUI();

    // Install event filter:
    QCoreApplication::instance()->installEventFilter(mEventWatcher);

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
}

// Set context properties:
void Controller::setContextProperties()
{
    mEngine.rootContext()->setContextProperty("_controller", this);
    mEngine.rootContext()->setContextProperty("_eventWatcher", mEventWatcher);
}

// Start GUI:
void Controller::startGUI()
{
    mEngine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
}

// Read asset salads:
void Controller::readSaladAssets()
{
    QDir saladAssetsDir = Utils::appDir();
    if (saladAssetsDir.cdUp())
    {
        if (saladAssetsDir.cd("salad_assets"))
        {
            QStringList filter;
            filter << "*.png";
            Utils::files(saladAssetsDir.absolutePath(), filter, mSaladAssets);
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

// Increment item count:
void Controller::incrementItemCount(const QString &vendItemName)
{
    mCartModel->incrementItemCount(vendItemName);
}

// Decrement item count:
void Controller::decrementItemCount(const QString &vendItemName)
{
    mCartModel->decrementItemCount(vendItemName);
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
    QRegExp regex("^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$");
    return regex.exactMatch(emailAddress);
}

// Validate coupon:
bool Controller::validateCoupon(const QString &coupon)
{
    Q_UNUSED(coupon);
    return true;
}
