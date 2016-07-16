import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import Common 1.0

Page {
    id: stockPagePrivate

    // Stop:
    function onStop()
    {
        if (xmlVersionModel)
            xmlVersionModel.source = ""
    }

    // XML version model:
    CustomXmlListModel {
        id: xmlVersionModel
        query: "/versionStatus/item"
        source: Utils.urlPlay(_controller.currentNetworkIP, "/config/versionStatus")

        XmlRole { name: "versionModel"; query: "version/string()"; isKey: true }
        XmlRole { name: "statusModel"; query: "status/string()"; isKey: true }
    }

    // XML row model:
    CustomXmlListModel {
        id: xmlRowModel
        query: "/restock/row"
        source: Utils.urlPlay(_controller.currentNetworkIP, "/config/restocks")

        XmlRole { name: "rowNumber"; query: "@rowId/string()"; isKey: true }
    }

    // Top bar:
    Item {
        id: topBar
        anchors.top: parent.top
        width: parent.width
        height: 64
        RowLayout {
            Layout.preferredWidth: body.width
            spacing: body.width/10
            height: parent.height
            anchors.centerIn: parent
            Button {
                id: stock
                text: qsTr("STOCK")
                onClicked: _restockFromTabletCommand.execute()
            }
            Button {
                id: clearAll
                text: qsTr("CLEAR ALL")
                onClicked: _clearAllCommand.execute()
            }
            Button {
                id: back
                text: qsTr("BACK")
                onClicked: pageMgr.loadPreviousPage()
            }
            Button {
                id: note
                text: qsTr("NOTE")

                // Notepad enter key clicked:
                function onNotePadEnterKeyClicked()
                {
                    mainWindow.logMessage("ENTER KEY CLICKED FOR NOTEPAD")
                    mainApplication.hideNotePad()

                    mainApplication.notePadEnterClicked.disconnect(onNotePadEnterKeyClicked)
                    mainApplication.notePadCancelKeyClicked.disconnect(onNotePadCancelKeyClicked)
                }

                // Notepad cancel key clicked:
                function onNotePadCancelKeyClicked()
                {
                    mainWindow.logMessage("CANCEL KEY CLICKED FOR NOTEPAD")
                    mainApplication.hideNotePad()

                    mainApplication.notePadEnterClicked.disconnect(onNotePadEnterKeyClicked)
                    mainApplication.notePadCancelKeyClicked.disconnect(onNotePadCancelKeyClicked)
                }

                onClicked: {
                    mainApplication.notePadEnterClicked.connect(onNotePadEnterKeyClicked)
                    mainApplication.notePadCancelKeyClicked.connect(onNotePadCancelKeyClicked)
                    mainApplication.showNodePad()
                }
            }
        }
    }

    // Body:
    Item {
        id: body
        height: parent.height
        width: parent.width-32
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top

        // Stock page grid:
        StockPageGrid {
            Layout.preferredWidth: body.width
            Layout.preferredHeight: body.height * .90
            Layout.alignment: Qt.AlignTop
        }
    }

    // Stock page footer block:
    Item {
        id: bottomBar
        width: parent.width
        height: 64
        anchors.bottom: parent.bottom
        StockPageHeaderBlock {
            id: header
            Layout.preferredWidth: body.width
            height: parent.height
            anchors.centerIn: parent
        }
    }
}
