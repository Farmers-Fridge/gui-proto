import QtQuick 2.2
import QtQuick.Window 2.2
import "script/Utils.js" as Utils

Window {
    id: mainWindow
    visibility: Window.FullScreen
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true    
    property bool imageLoading: false
    color: _settings.mainWindowColor

    // Application data:
    property variant _appData: undefined

    // Category model:
    property variant _categoryModel: undefined

    // Settings:
    Settings {
        id: _settings
    }

    // XML parser:
    XMLParser {
        id: _xmlParser
        url: "qrc:/qml/json/application.json"
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
