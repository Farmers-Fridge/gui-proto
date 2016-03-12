import QtQuick 2.4

Rectangle {
    color: "transparent"
    border.color: _settings.appGreen
    border.width: 1

    // Cancel button:
    ImageButton {
        id: cancelButton
        height: parent.height-4
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
        source: "qrc:/qml/images/ico-logo1.png"
        opacity: _viewState !== "fullscreen" ? 1 : 0
        Behavior on opacity {
            NumberAnimation {duration: 500}
        }
    }

    // Add:
    ImageButton {
        anchors.centerIn: parent
        height: parent.height-4
        source: "qrc:/qml/images/ico-plus.png"
        opacity: _viewState === "fullscreen" ? 1 : 0
        Behavior on opacity {
            NumberAnimation {duration: 500}
        }
        onClicked: mainApplication.addCurrentItem()
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
        height: parent.height-4
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-checkout.png"
        onClicked: _checkOutCommand.execute()
        enabled: _controller.cartModel.cartCount > 0
    }
}


