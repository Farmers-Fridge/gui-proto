import QtQuick 2.2
import QtQuick.Window 2.2
import "script/Utils.js" as Utils

Window {
    id: mainWindow
    visibility: Window.FullScreen
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true

    // Application data:
    property variant _appData: undefined

    // Category model:
    property variant _categoryModel: undefined

    // Verbose mode:
    property bool _verbose: false

    // Log message:
    function logMessage(msg)
    {
        if (_verbose)
            console.log(msg)
    }

    // XML parser:
    XMLParser {
        id: _xmlParser
        url: "qrc:/qml/json/application.json"
        onDataReady: {
            // Log:
            mainWindow.logMessage("Loaded application.json")

            // Set application data:
            _appData = JSON.parse(responseText)

            // Log:
            mainWindow.logMessage("Response text: " + responseText)

            // Update title:
            mainWindow.title = _appData.appName + "/" + _appData.clientName

            // Load main application:
            mainApplicationAppLoader.sourceComponent = mainApplicationComponent
        }
    }

    // Category loader:
    Loader {
        id: categoryLoader
    }

    // Main application loader:
    Loader {
        id: mainApplicationAppLoader
        anchors.fill: parent
    }

    // Main application component:
    Component {
        id: mainApplicationComponent
        MainApplication {
            id: mainApplication
        }
    }
}
