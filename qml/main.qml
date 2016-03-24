import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0
import "script/Utils.js" as Utils

Window {
    id: mainWindow
    visibility: Window.Maximized
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
            categoryLoader.sourceComponent = categoryComponent
        }
    }

    // Category component:
    Component {
        id: categoryComponent

        // XML version model:
        XmlListModel {
            id: categoryModel
            source: Utils.urlPlay(_appData.categorySource)
            query: _appData.categoryQuery

            XmlRole { name: "categoryName"; query: "categoryName/string()"; isKey: true }
            XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
            XmlRole { name: "header"; query: "header/string()"; isKey: true }

            onStatusChanged: {
                // Load main application:
                if (status !== XmlListModel.Loading)
                {
                    // Error:
                    if (status === XmlListModel.Error)
                    {
                        // Log:
                        console.log("Can't load: " + source)
                    }
                    else
                    // Model ready:
                    if (status === XmlListModel.Ready)
                    {
                        // Set current category name:
                        _controller.currentCategory = categoryModel.get(0).categoryName

                        // Set category model:
                        _categoryModel = categoryModel

                        // Load main application:
                        mainApplicationAppLoader.sourceComponent = mainApplicationComponent

                        // Log:
                        console.log(source + " loaded successfully")
                    }
                }
            }
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
