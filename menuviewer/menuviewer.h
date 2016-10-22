#ifndef MENUVIEWER_H
#define MENUVIEWER_H

// Application:
#include "iservice.h"

// Qt:
#include <QObject>

class Controller;

// Main application:
class MenuViewer : public QObject, public IService
{
    Q_OBJECT

public:
    // Return an instance of MenuViewer:
    static MenuViewer *instance();

    // Startup:
    virtual bool startup();

    // Shutdown:
    virtual void shutdown();

    // Destructor:
    virtual ~MenuViewer() {

    }

private:
    // Constructor:
    MenuViewer(QObject *parent=0);

private:
    // Farmers Fridge singleton:
    static MenuViewer *sMenuViewer;

    // Controller singleton:
    Controller *mController;
};

#endif // MENUVIEWER_H
