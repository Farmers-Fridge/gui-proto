import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

DialogTemplate {
    id: userDialogTemplate
    property int blockSize: 48
    width: 544
    implicitHeight: (_controller.cartModel.cartCount+1)*blockSize

    // User area:
    contents: Item {
        id: userArea
        anchors.fill: parent

        ListView {
            id: cartView
            clip: true
            model: _controller.cartModel
            snapMode: ListView.SnapOneItem
            spacing: 4
            anchors.fill: parent

            // Row colors:
            delegate: Item {
                id: delegate
                width: parent.width
                height: blockSize

                Item {
                    id: row
                    anchors.fill: parent
                    Item {
                        id: itemDesc
                        anchors.fill: parent

                        // Vend item name and quantity:
                        StandardText {
                            width: parent.width
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            wrapMode: Text.WordWrap
                            text: vendItemName + " * " + count
                            color: _colors.ffColor7
                            horizontalAlignment: Text.AlignLeft
                        }

                        // Price:
                        StandardText {
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            text: "$"+count*price
                        }
                    }
                }
            }
        }
    }
}

