import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import Common 1.0
import Components 1.0

Page {
    id: stockPagePrivate

    // Modified stock item list:
    property var modifiedStockItemList: []

    // OK clicked on notepad:
    function onOKClicked(enteredText)
    {
        console.log("YOU ENTERED: ", enteredText)
        notepad.state = ""
    }

    // Stop stock page private:
    function onStopStockPagePrivate()
    {
        xmlRowModel.source = ""
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
                onClicked: {
                    // Stringify list of modified stock items:
                    var modifiedStockItemListStr = JSON.stringify(modifiedStockItemList)

                    // Pass string of modified stock items:
                    _restockFromTabletCommand.modifiedStockItems = modifiedStockItemListStr

                    // Execute:
                    _restockFromTabletCommand.execute()
                }
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
                    notepad.notepadLabel = qsTr("Please Enter Notes")
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
