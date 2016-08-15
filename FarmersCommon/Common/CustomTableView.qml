import QtQuick 2.5
import QtQuick.Controls 1.4
import Components 1.0
import Common 1.0

Item {
    // Target url:
    property string targetUrl

    // Target columns:
    property variant targetColumns

    // Update time:
    property int updateTime

    // Start timer:
    function start()
    {
        timer.start()
    }

    // Stop timer:
    function stop()
    {
        timer.stop()
    }

    // Timer:
    Timer {
        id: timer
        interval: updateTime
        repeat: true
        triggeredOnStart: true
        onTriggered: load(targetUrl)
    }

    // XML parser:
    XMLParser {
        id: xmlParser
        onDataReady: {
            if (responseText.length > 0)
            {
                _tableModel.load(responseText, targetColumns)
                tableViewLoader.sourceComponent = tableViewComponent
            }
        }
    }

    // Load:
    function load(url)
    {
        console.log("RELOADING: ", url)
        xmlParser.url = url
    }

    // Table view loader:
    Loader {
        id: tableViewLoader
        anchors.fill: parent
    }

    // Table view component:
    Component {
        id: tableViewComponent

        // Main list view:
        ListView {
            id: listView
            anchors.fill: parent
            model: _tableModel
            header: Rectangle {
                width: parent.width
                height: 48
                color: "lightgray"
                Row {
                    anchors.fill: parent
                    Repeater {
                        model: _tableModel.colCount
                        Item {
                            width: parent.width/_tableModel.colCount
                            height: parent.height
                            StandardText {
                                anchors.centerIn: parent
                                text: _tableModel.targetCols[index].toUpperCase()
                                color: "black"
                            }
                            Rectangle {
                                color: "black"
                                anchors.right: parent.right
                                width: 1
                                height: parent.height
                            }
                        }
                    }
                }
            }

            delegate: Rectangle {
                width: parent.width
                height: 64
                color: index%2 === 0 ? "white" : "lightgray"
                Row {
                    width: parent.width
                    height: 64
                    Repeater {
                        model: _tableModel.colCount
                        Item {
                            width: parent.width/_tableModel.colCount
                            height: parent.height
                            Item {
                                anchors.fill: parent
                                StandardText {
                                    anchors.centerIn: parent
                                    text: _tableModel.getCellData(index, rowIndex)
                                    color: _tableModel.getCellColor(index, rowIndex)
                                    font.pixelSize: 16
                                }
                                Rectangle {
                                    color: "black"
                                    anchors.right: parent.right
                                    width: 1
                                    height: parent.height
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
