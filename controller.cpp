#include "controller.h"
#include "utils.h"
#include "eventwatcher.h"
#include "cartmodel.h"
#include <QQmlContext>
#include <QSettings>
#include <QDebug>

// Constructor:
Controller::Controller(QObject *parent) : QObject(parent),
    mEventWatcher(0), mCartModel(0)
{
    // Define application keys:
    mAppKeys << "CURRENT_ROUTE" << "CURRENT_IP";

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
    // Load application parameters:
    loadApplicationParameters();

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
    saveApplicationParameters();
}

// Register types:
void Controller::registerTypes()
{
    // TO DO
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

// Load application parameters:
void Controller::loadApplicationParameters()
{
    // Read preferences.ini:
    QString preferencesFile = Utils::pathToPreferencesDotIni();
    QFileInfo fi(preferencesFile);
    if (!fi.exists())
    {
        // No preferences.ini found, set default parameters:
        setDefaultParameters();
        return;
    }
    qDebug() << "READING: " << preferencesFile << " INI FILE";

    QSettings settings(preferencesFile, QSettings::IniFormat);
    settings.beginGroup("Parameter");

    // Get all keys:
    QStringList allKeys = settings.allKeys();

    bool settingsOK = true;
    for (int i=0; i<allKeys.size(); i++)
    {
        // Get actual parameter name:
        QString actualParameter = allKeys[i].simplified().toUpper();

        // Expected?
        if (!mAppKeys.contains(actualParameter))
            continue;

        // Read:
        QString value = settings.value(allKeys[i]).toString();
        if (value.simplified().isEmpty())
        {
            settingsOK = false;
            break;
        }
        mAppParameters[actualParameter] = settings.value(allKeys[i]);
    }

    // Settings not OK:
    if (!settingsOK)
        setDefaultParameters();

    settings.endGroup();
}

// Save application parameters:
void Controller::saveApplicationParameters()
{
    qDebug() << "SAVING APPLICATION PARAMETERS";
}

// Set default parameters:
void Controller::setDefaultParameters()
{
    mAppParameters.clear();
    mAppParameters["CURRENT_ROUTE"] = "https://bytebucket.org/jacbop/kiosk-assets/raw/master";
    mAppParameters["CURRENT_IP"] = "166.130.89.142";
}

// Return current route:
QString Controller::currentRoute() const
{
    return mAppParameters["CURRENT_ROUTE"].toString();
}

// Return current IP:
QString Controller::currentIP() const
{
    return mAppParameters["CURRENT_IP"].toString();
}

// Return cart model:
QObject *Controller::cartModel() const
{
    return mCartModel;
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
