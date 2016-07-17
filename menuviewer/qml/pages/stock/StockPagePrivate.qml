import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import Common 1.0

Page {
    id: stockPagePrivate

    // OK clicked on notepad:
    function onOKClicked(enteredText)
    {
        console.log("YOU ENTERED: ", enteredText)
        notepad.state = ""
    }

    // XML row model:
    CustomXmlListModel {
        id: xmlRowModel
        query: "/restock/row"
        source: Utils.urlPlay(_controller.currentNetworkIP, "/config/restocks")

        XmlRole { name: "rowNumber"; query: "@rowId/string()"; isKey: true }
        onStatusChanged: _appIsBusy = (status === XmlListModel.Loading)
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
                    notepad.invoker = stockPagePrivate
                    notepad.state = "on"
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
        anchors.bottom: parent.bottom

        // Stock page grid:
        StockPageGrid {
            Layout.preferredWidth: body.width
            Layout.preferredHeight: body.height * .90
            Layout.alignment: Qt.AlignTop
        }
    }
}
