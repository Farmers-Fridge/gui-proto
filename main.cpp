#include <QApplication>
#include "menuviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Launch application:
    MenuViewer *menuViewer = MenuViewer::instance();
    if (!menuViewer)
        return 0;

     // Start application:
    if (menuViewer->startup())
        // Run:
        app.exec();

    // Shutdown:
    menuViewer->shutdown();

    // Delete application:
    delete menuViewer;

    return 1;
}
