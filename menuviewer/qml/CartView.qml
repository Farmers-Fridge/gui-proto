import QtQuick 2.5
import Common 1.0

ListView {
    id: cartView
    clip: true
    model: _controller.cartModel
    snapMode: ListView.SnapOneItem
    delegate: Item {
        id: delegate
        width: parent.width
        height: cartView.height/4
        Row {
            id: row
            anchors.fill: parent
            Item {
                width: parent.width/2
                height: parent.height

                // Image loading background
                Rectangle {
                    id: imageLoadingBkg
                    color: "white"
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: parent.height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    visible: originalImage.status !== Image.Ready
                    Rectangle {
                        color: "darkgreen"
                        antialiasing: true
                        anchors { fill: parent; margins: 3 }
                    }
                }

                // Original image:
                Image {
                    id: originalImage
                    antialiasing: true
                    source: Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
                    cache: true
                    fillMode: Image.PreserveAspectFit
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: parent.height
                    height: parent.height

                    // Busy indicator:
                    BusyIndicator {
                        id: busyIndicator
                        anchors.centerIn: parent
                        on: originalImage.status === Image.Loading
                        visible: on
                    }
                }

                // Vend item name:
                CommonText {
                    anchors.left: imageLoadingBkg.right
                    anchors.leftMargin: 8
                    anchors.top: parent.top
                    text: vendItemName
                    font.italic: true
                    color: _settings.ffGreen
                }
            }

            // Incremental button:
            Item {
                width: parent.width/4
                height: parent.height

                // Incremental button:
                IncrementalButton {
                    anchors.centerIn: parent
                    value: count
                    minValue: 0
                    maxValue: 10
                    onValueChanged: {
                        if (value !== count)
                            _controller.setItemCount(value, vendItemName)
                    }
                }
            }

            // Total:
            Item {
                width: parent.width/4
                height: parent.height
                CommonText {
                    anchors.centerIn: parent
                    text: "$"+count*price
                }
            }
        }
    }
}
