import QtQuick 2.5
import QtQuick.Window 2.2
import Common 1.0
import Components 1.0

Window {
    id: mainWindow
    visibility: Window.Maximized
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true

    property var query: [
        {"row": 1, "col": 1, "par": 1}
    ]

    // Application data:
    property variant _appData

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
            mainWindow.title = _appData.general.appName + "/" + _appData.general.clientName

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

    HttpPostClient {
        id: httpPostClient
        url: "http://52.0.49.170:9000/post/restockFromTablet"
        contentType: "application/json"
        query: JSON.stringify(mainWindow.query)

    }

    Component.onCompleted: {
        httpPostClient.post()
    }

}
