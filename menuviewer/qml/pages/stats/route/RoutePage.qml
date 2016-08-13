import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0

Page {
    property int blockSize: 256

    // XML route model:
    CustomXMLListModel {
        id: xmlRouteModel
        query: "/hosts/item"
        source: _appData.routes
        XmlRole { name: "name"; query: "name/string()"; isKey: true }
        XmlRole { name: "file"; query: "file/string()"; isKey: true }
    }

    Item {
        id: container
        width: 3*blockSize
        height: 3*blockSize
        anchors.centerIn: parent

        GridView {
            id: gridView
            anchors.fill: parent
            model: xmlRouteModel
            cellWidth: blockSize
            cellHeight: blockSize
            delegate: Item {
                width: blockSize
                height: blockSize
                Rectangle {
                    color: _colors.ffGreen
                    anchors.fill: parent
                    anchors.margins: 8
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainApplication._selectedRoute = _appData.httpPrefix + file
                            mainApplication.loadNextPage()
                        }
                    }
                    CommonText {
                        anchors.centerIn: parent
                        color: _colors.ffWhite
                        text: name
                    }
                }
            }
        }
    }

    // Return next page id:
    function nextPageId()
    {
        return "NETWORK"
    }
}

