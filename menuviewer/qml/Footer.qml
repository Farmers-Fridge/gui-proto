import QtQuick 2.5
import Common 1.0

Rectangle {
    color: _settings.bkgColor
    property alias bottomAreaSource: bottomArea.source
    property alias homeVisible: homeButton.visible
    property alias pigVisible: pigButton.visible
    property alias cartVisible: cartButton.visible
    signal homeClicked()
    signal pigClicked()
    signal cartClicked()

    // Home button:
    ImageButton {
        id: homeButton
        anchors.bottom: bottomAreaContainer.top
        anchors.left: parent.left
        anchors.leftMargin: 8
        source: "qrc:/assets/ico-home.png"
        height: parent.height/2
        onClicked: homeClicked()
    }

    // Cart button:
    ImageButton {
        id: cartButton
        anchors.bottom: bottomAreaContainer.top
        anchors.right: parent.right
        anchors.rightMargin: 8
        source: "qrc:/assets/ico-cart.png"
        height: parent.height/2
        onClicked: cartClicked()

        CommonText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -21
            anchors.verticalCenterOffset: -16
            color: _settings.ffGreen
            text: _cartModel.cartCount
            visible: _cartModel.cartCount > 0
        }
    }

    // Pig button:
    ImageButton {
        id: pigButton
        anchors.bottom: bottomAreaContainer.top
        anchors.right: cartButton.left
        anchors.rightMargin: 8
        source: "qrc:/assets/ico-pig.png"
        height: parent.height/2
        onClicked: pigClicked()
    }

    // Footer:
    Item {
        id: bottomAreaContainer
        width: parent.width
        height: parent.height/2
        anchors.bottom: parent.bottom
        Image {
            id: bottomArea
            anchors.fill: parent
            fillMode: Image.Stretch
        }
    }
}

