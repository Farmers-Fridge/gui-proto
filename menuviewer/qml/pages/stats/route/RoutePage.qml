import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0
import "../../.."

PageTemplate {
    property int blockSize: 256
    headerVisible: false

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // XML route model:
    CustomXmlListModel {
        id: xmlRouteModel
        query: "/hosts/item"
        source: _appData.routes
        XmlRole { name: "name"; query: "name/string()"; isKey: true }
        XmlRole { name: "file"; query: "file/string()"; isKey: true }
    }

    contents: Item {
        id: container
        anchors.fill: parent

        // Icon:
        Image {
            id: logo
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/assets/ico-logo.png"
        }

        Item {
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
                        color: _colors.ffColor3
                        anchors.fill: parent
                        anchors.margins: 8
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                mainApplication._selectedRoute = _appData.httpPrefix + file
                                pageMgr.loadNextPage()
                            }
                        }
                        StandardText {
                            anchors.centerIn: parent
                            color: _colors.ffColor16
                            text: name
                        }
                    }
                }
            }
        }
    }

    // Return next page id:
    function nextPageId()
    {
        return "STATS_NETWORK_PAGE"
    }
}

