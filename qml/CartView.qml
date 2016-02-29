import QtQuick 2.4
import "script/Utils.js" as Utils

ListView {
    id: cartView
    clip: true
    model: _controller.cartModel
    snapMode: ListView.SnapOneItem
    delegate: Item {
        width: parent.width
        height: _settings.cartViewDelegateHeight

        Row {
            anchors.fill: parent
            Row {
                width: parent.width/3
                height: parent.height

                // Item icon:
                Image {
                    id: image
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: height
                    fillMode: Image.PreserveAspectFit
                    source: Utils.urlPublicStatic(icon)
                }

                // Vend item name:
                Item {
                    anchors.verticalCenter: image.verticalCenter
                    height: image.height/2
                    width: image.width
                    Column {
                        // Vend item name:
                        CommonText {
                            text: vendItemName
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
                    onIncrement: _controller.incrementItemCount(vendItemName)
                    onDecrement: _controller.decrementItemCount(vendItemName)
                }
            }

            // Price:
            Item {
                width: parent.width*5/36
                height: parent.height
                CommonText {
                    anchors.centerIn: parent
                    text: "$"+price
                    font.pixelSize: 30
                }
            }

            // Total:
            Item {
                width: parent.width*5/36
                height: parent.height
                CommonText {
                    anchors.centerIn: parent
                    text: "$"+count*price
                    font.pixelSize: 30
                }
            }

            // Trash:
            Item {
                width: parent.width*5/36
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
