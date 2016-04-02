import QtQuick 2.5
import "script/Utils.js" as Utils

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
                width: parent.width*2/5
                height: parent.height

                // Item icon:
                Image {
                    id: image
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    height: parent.height-16
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: Utils.urlPublicStatic(icon)
                }

                // Price:
                Item {
                    anchors.left: image.right
                    anchors.right: parent.right
                    height: parent.height

                    // Price:
                    CommonText {
                        anchors.centerIn: parent
                        text: "($"+price+")"
                    }
                }
            }

            // Incremental button:
            Item {
                width: parent.width/5
                height: parent.height

                // Incremental button:
                IncrementalButton {
                    anchors.fill: parent
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
            color: _settings.green
        }
    }
}
