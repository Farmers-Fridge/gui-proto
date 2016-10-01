import QtQuick 2.5
import QtQuick.Window 2.2
import Common 1.0

Window {
    id: mainWindow
    visibility: Window.FullScreen
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true

    // Application data:
    property variant _appData: undefined

    // Verbose mode:
    property bool _verbose: false

    // Settings:
    Settings {
        id: _settings
    }

    // XML parser:
    XMLParser {
        id: _xmlParser
        url: "qrc:/json/application.json"
        onDataReady: {
            // Log:
            console.log("Loaded application.json")

            // Set application data:
            _appData = JSON.parse(responseText)

            // Log:
            console.log("Response text: " + responseText)

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
