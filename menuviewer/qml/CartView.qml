import QtQuick 2.5
import Common 1.0

ListView {
    id: cartView
    clip: true
    model: _controller.cartModel
    snapMode: ListView.SnapOneItem
    spacing: 4

    // Row colors:
    property variant rowColors: [_colors.ffColor17, _colors.ffColor18, _colors.ffColor19]
    delegate: Item {
        id: delegate
        width: parent.width
        height: _settings.cartViewRowHeight

        Row {
            id: row
            anchors.fill: parent
            Item {
                id: leftArea
                width: parent.width/2
                height: parent.height

                // Image loading background
                Rectangle {
                    id: imageLoadingBkg
                    color: _colors.ffColor16
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: parent.height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    visible: originalImage.status !== Image.Ready
                    Rectangle {
                        color: _colors.ffColor3
                        antialiasing: true
                        anchors { fill: parent; margins: 3 }
                    }
                }

                // Original image:
                Image {
                    id: originalImage
                    antialiasing: true
                    source: getImageSource(category, icon, false)
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
                Rectangle {
                    anchors.left: imageLoadingBkg.right
                    anchors.right: parent.right
                    height: parent.height
                    color: rowColors[index%3]

                    StandardText {
                        width: parent.width
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        text: vendItemName
                        font.italic: true
                        color: _colors.ffColor7
                    }
                }
            }

            // Incremental button:
            Rectangle {
                id: centralArea
                width: parent.width/4
                height: parent.height
                color: rowColors[index%3]

                // Quantity:
                StandardText {
                    text: qsTr("Quantity: ") + incButton.value
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Incremental button:
                IncrementalButton {
                    id: incButton
                    anchors.centerIn: parent
                    value: count
                    minValue: 0
                    maxValue: 10
                    onValueChanged: {
                        if (value !== count) {
                            _controller.setItemCount(value, vendItemName)
                            if (_cartModel.cartCount < 1)
                                _pageMgr.loadPreviousPage()
                        }
                    }
                }
            }

            // Total:
            Rectangle {
                id: rightArea
                width: parent.width/4
                height: parent.height
                color: rowColors[index%3]
                StandardText {
                    anchors.centerIn: parent
                    text: "$"+count*price
                }
            }
        }
    }
}
