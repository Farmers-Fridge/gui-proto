import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0
import "../.."

PageTemplate {
    id: stockPage
    signal stopStockPagePrivate()

    // Time out:
    function onIdleTimeOut()
    {
        stopStockPagePrivate()
        pageMgr.loadPreviousPage()
    }

    // Setup page:
    function setup()
    {
        pageLoader.sourceComponent = undefined
        pageLoader.sourceComponent = pageComponent
    }

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    contents: Item {
        anchors.fill: parent

        // Page loader:
        Loader {
            id: pageLoader
            anchors.fill: parent
        }

        // Page component:
        Component {
            id: pageComponent
            StockPagePrivate {
                id: stockPagePrivate
                anchors.fill: parent
                opacity: 1
            }
        }

        // Setup stock page:
        Component.onCompleted: {
            console.log("SETTING UP STOCK PAGE")
            setup()
        }
    }

    /* TO DO
    footer: Item {
        anchors.fill: parent

        // Display server label:
        Item {
            width: parent.width
            height: parent.height/2
            anchors.bottom: parent.bottom

            CommonText {
                id: serverLabel
                anchors.centerIn: parent
                color: "white"
            }
        }

        // XML version model:
        CustomXmlListModel {
            id: xmlVersionModel
            query: "/versionStatus/item"
            source: Utils.urlPlay(_controller.currentNetworkIP, "/config/versionStatus")

            XmlRole { name: "versionModel"; query: "version/string()"; isKey: true }
            XmlRole { name: "statusModel"; query: "status/string()"; isKey: true }

            onStatusChanged: {
                _appIsBusy = (status === XmlListModel.Loading)
                if (status === XmlListModel.Ready) {
                    var versionModel = xmlVersionModel.get(0).versionModel
                    var statusModel = xmlVersionModel.get(0).statusModel
                    serverLabel.text = versionModel + " " + statusModel
                }
            }
        }
    }
    */
}
