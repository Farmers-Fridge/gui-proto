import QtQuick 2.4
import "script/Utils.js" as Utils

ListView {
    id: cartView
    clip: true
    model: _controller.cartModel
    snapMode: ListView.SnapOneItem
    delegate: Item {
        id: delegate
        width: parent.width
        height: _settings.cartViewDelegateHeight

        Row {
            id: row
            anchors.fill: parent
            Row {
                width: parent.width*2/5
                height: parent.height

                Item {
                    id: imageContainer
                    width: parent.width/2
                    height: parent.height

                    // Item icon:
                    Image {
                        id: image
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: Utils.urlPublicStatic(icon)
                        onStatusChanged: {
                            if (status === Image.Ready)
                                delegate.height = Math.max(_settings.cartViewDelegateHeight, image.paintedHeight)
                        }
                    }
                }

                // Vend item name:
                Item {
                    anchors.top: imageContainer.top
                    anchors.topMargin: 8
                    width: parent.width/2
                    height: parent.height
                    Column {
                        width: parent.width
                        height: parent.height

                        // Vend item name:
                        CommonText {
                            text: vendItemName
                            width: parent.width
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                        }

                        // More info:
                        CommonText {
                            text: '<html><style type="text/css"></style><a href="http://google.com">more info...</a></html>'
                            //onLinkActivated: Qt.openUrlExternally(link)
                            verticalAlignment: Text.AlignVCenter
                            color: _settings.appGreen
                        }
                    }

                    // Price:
                    CommonText {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8
                        text: "$"+price
                        font.pixelSize: 30
                    }
                }
            }

            // Incremental button:
            Item {
                width: parent.width/5
                height: parent.height

                // Incremental button:
                IncrementalButton {
                    anchors.centerIn: parent
                    value: count
                    onIncrement: _controller.incrementItemCount(vendItemName)
                    onDecrement: _controller.decrementItemCount(vendItemName)
                }
            }

            // Total:
            Item {
                width: parent.width/5
                height: parent.height
                CommonText {
                    anchors.centerIn: parent
                    text: "$"+count*price
                    font.pixelSize: 30
                }
            }

            // Trash:
            Item {
                width: parent.width/5
                height: parent.height
                ImageButton {
                    anchors.centerIn: parent
                    source: "qrc:/qml/images/ico-trash.png"
                    onClicked: _controller.removeItem(vendItemName)
                }
            }
        }

        // Separator:
        Rectangle {
            anchors.bottom: parent.bottom
            height: 1
            width: parent.width
            color: _settings.appGreen
        }
    }
}
