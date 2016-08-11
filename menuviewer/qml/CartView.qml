import QtQuick 2.5
import Common 1.0

ListView {
    id: cartView
    clip: true
    model: _controller.cartModel
    snapMode: ListView.SnapOneItem
    spacing: 4

    // Row colors:
    property variant rowColors: [_settings.ffRowColor1, _settings.ffRowColor2, _settings.ffRowColor3]
    delegate: Item {
        id: delegate
        width: parent.width
        height: _settings.cartViewRowHeight

        // Get image source:
        function getImageSource()
        {
            var source = ""

            // Off line:
            if (_appData.offline_mode === "1")
            {
                // TO DO
                source = _controller.fromLocalFile(_controller.offLinePath + "/" + category + "/Square Thumbnails/" + icon)
            }
            else
            // In line:
            {
                source = Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
            }

            console.log("********************** USING SOURCE: ", source)

            return source
        }

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
                    color: _settings.ffWhite
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: parent.height
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    visible: originalImage.status !== Image.Ready
                    Rectangle {
                        color: _settings.ffGreen
                        antialiasing: true
                        anchors { fill: parent; margins: 3 }
                    }
                }

                // Original image:
                Image {
                    id: originalImage
                    antialiasing: true
                    source: getImageSource()
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
                        color: _settings.ffGray
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
                        if (value !== count)
                            _controller.setItemCount(value, vendItemName)
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
