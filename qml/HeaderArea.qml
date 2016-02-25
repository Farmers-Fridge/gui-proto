import QtQuick 2.4

// Header:
Item {
    id: header

    // Cancel button:
    ImageButton {
        id: cancelButton
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-cancel.png"
        onClicked: _exitCommand.execute()
    }

    // Cart count:
    Item {
        anchors.left: cancelButton.right
        anchors.right: logo.left
        height: parent.height
        CommonText {
            anchors.centerIn: parent
            text: _controller.cartModel.cartCount + " items"
            font.pixelSize: 32
        }
    }

    // Logo:
    Image {
        id: logo
        anchors.centerIn: parent
        source: "qrc:/qml/images/ico-logo.png"
    }

    // Cart total:
    Item {
        anchors.left: logo.right
        anchors.right: checkOutButton.left
        height: parent.height
        CommonText {
            anchors.centerIn: parent
            text: "$ " + _controller.cartModel.cartTotal
            font.pixelSize: 32
        }
    }

    // Checkout button:
    ImageButton {
        id: checkOutButton
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-checkout.png"
        onClicked: _checkOutCommand.execute()
    }
}

