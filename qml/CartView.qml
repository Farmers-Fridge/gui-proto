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

        // Item icon:
        Image {
            id: image
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            width: height
            fillMode: Image.PreserveAspectFit
            source: Utils.urlPublicStatic(icon)
        }

        // Vend item name:
        CommonText {
            anchors.left: image.right
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            text: vendItemName
        }

        // Price:
        CommonText {
            anchors.left: image.right
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            text: count + " X $" + price
        }

        // Separator:
        Rectangle {
            anchors.bottom: parent.bottom
            height: 1
            width: parent.width
            color: _settings.cartViewBorderColor
        }

        // Incremental button:
        IncrementalButton {
            anchors.left: image.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            value: count
            onIncrement: _controller.incrementItemCount(vendItemName)
            onDecrement: _controller.decrementItemCount(vendItemName)
        }
    }
}
