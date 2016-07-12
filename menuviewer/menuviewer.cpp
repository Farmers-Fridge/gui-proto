#include "menuviewer.h"
#include "controller.h"
#include <QDebug>

// Farmers fridge singleton:
MenuViewer *MenuViewer::sMenuViewer = 0;

// Constructor:
MenuViewer::MenuViewer(QObject *parent)
{
    Q_UNUSED(parent);
    mController = new Controller(this);
}

// Return kemanage singleton:
MenuViewer *MenuViewer::instance()
{
    if (!sMenuViewer)
        sMenuViewer = new MenuViewer();

    return sMenuViewer;
}

// Startup:
bool MenuViewer::startup()
{
    qDebug() << "START APP";

    // Start controller:
    if (!mController->startup())
        return false;

    return true;
}

// Shutdown:
void MenuViewer::shutdown()
{
    qDebug() << "SHUT DOWN APP";

    // Shutdown controller:
    mController->shutdown();
}
