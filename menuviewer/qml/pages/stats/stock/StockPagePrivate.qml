import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import Common 1.0

Item {
    id: stockPagePrivate

    function initialize()
    {
        xmlVersionModel.query = "/versionStatus/item"
        xmlVersionModel.source = Utils.urlPlay(_controller.currentNetworkIP, "/config/versionStatus")

        xmlRowModel.query = "/restock/row"
        xmlRowModel.source = Utils.urlPlay(_controller.currentNetworkIP, "/config/restocks")
    }

    // XML version model:
    CustomXMLListModel {
        id: xmlVersionModel
        XmlRole { name: "versionModel"; query: "version/string()"; isKey: true }
        XmlRole { name: "statusModel"; query: "status/string()"; isKey: true }
    }

    // XML row model:
    CustomXMLListModel {
        id: xmlRowModel
        XmlRole { name: "rowNumber"; query: "@rowId/string()"; isKey: true }
    }

    // Body:
    Item {
        id: body
        width: parent.width-32
        height: parent.height
        anchors.centerIn: parent

        // Stock page grid:
        StockPageGrid {
            Layout.preferredWidth: body.width
            Layout.preferredHeight: body.height * .90
            Layout.alignment: Qt.AlignTop
        }
    }

    // Bottom bar:
    Item {
        id: bottomBar
        width: parent.width
        height: _settings.toolbarHeight
        anchors.bottom: parent.bottom
        StockPageHeaderBlock {
            id: header
            Layout.preferredWidth: body.width
            height: parent.height
            anchors.centerIn: parent
        }
    }
}
