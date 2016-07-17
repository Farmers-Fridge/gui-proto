import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.XmlListModel 2.0
import Common 1.0

Rectangle {
    id: stockPageRow
    color: _settings.ffTransparent
    border.color: _settings.ffGreen

    // Row number:
    property int rowNumber: -1

    // Item spacing:
    property int itemSpacing: 12

    // Previous par values:
    property variant previousParValues: []

    // Row label:
    Item {
        id: label
        anchors.left: parent.left
        height: stockPageRow.height
        width: (stockPageRow.width * .05)
        CommonText {
            anchors.centerIn: parent
            text: rowNumber
            font.pixelSize: 36
        }
    }

    // Buttons:
    Item {
        id: buttons
        anchors.right: parent.right
        height: stockPageRow.height
        width: (stockPageRow.width *.95)
        ListView {
            id: stockGridColumns
            anchors.fill: parent
            orientation: ListView.Horizontal
            clip: false
            snapMode: ListView.SnapToItem
            interactive: false
            cacheBuffer: buttons.width
            model: CustomXmlListModel {
                id: xmlColumnModel
                source: Utils.urlPlay(_controller.currentNetworkIP, "/config/restocks")
                query: "/restock/row[" + rowNumber + "]/column"

                XmlRole { name: "columnNumber"; query: "@columnId/string()"; isKey: true }
                XmlRole { name: "vendItemName"; query: "title/string()"; isKey: true }
                XmlRole { name: "iconUrl"; query: "icon/string()"; isKey: true }
                XmlRole { name: "actualPar"; query: "actualPar/string()"; isKey: true }
                XmlRole { name: "actualPull"; query: "actualPull/string()"; isKey: true }
                XmlRole { name: "actualAdd"; query: "actualAdd/string()"; isKey: true }
                XmlRole { name: "theoPar"; query: "theoPar/string()"; isKey: true }
                XmlRole { name: "theoExpired"; query: "expired/string()"; isKey: true }
                XmlRole { name: "theoAdds"; query: "theoAdd/string()"; isKey: true }

                // Processing complete:
                function onUpdateRestockExceptionCommandSucces(response)
                {
                    // Reload:
                    if (xmlColumnModel)
                    {
                        // Disconnect:
                        _updateRestockExceptionCommand.cmdSuccess.disconnect(xmlColumnModel.onUpdateRestockExceptionCommandSucces)
                        _updateRestockExceptionCommand.cmdError.disconnect(xmlColumnModel.onUpdateRestockExceptionCommandError)

                        var children = stockGridColumns.children

                        // Reload:
                        xmlColumnModel.reload()
                    }

                    // Update app busy state:
                    _appIsBusy = false
                }

                // Processing complete:
                function onUpdateRestockExceptionCommandError(error)
                {
                    // Disconnect:
                    _updateRestockExceptionCommand.cmdSuccess.disconnect(xmlColumnModel.onUpdateRestockExceptionCommandSucces)
                    _updateRestockExceptionCommand.cmdError.disconnect(xmlColumnModel.onUpdateRestockExceptionCommandError)
                }

                onStatusChanged: _appIsBusy = (status === XmlListModel.Loading)
            }

            // Delegate:
            delegate: StockItem {
                id: stockItem
                width: buttons.width/xmlColumnModel.count-8
                height: buttons.height
            }
        }
    }
}
