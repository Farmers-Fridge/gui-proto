import QtQuick 2.5
import Common 1.0

Rectangle {
    color: _settings.ffIvoryLight
    property alias bottomAreaSource: bottomArea.source
    property alias bottomAreaContainer: bottomAreaContainer
    property alias homeVisible: homeButton.visible
    property alias emailVisible: emailButton.visible
    property alias couponVisible: couponButton.visible
    property alias pigVisible: pigButton.visible
    property alias cartVisible: cartButton.visible
    property alias footerRightText: footerRightText.text
    property alias footerRightTextVisible: footerRightText.visible
    property alias footerCentralText: footerCentralText.text
    property alias footerCentralTextVisible: footerCentralText.visible
    signal homeClicked()
    signal emailClicked()
    signal couponClicked()
    signal pigClicked()
    signal cartClicked()

    // Top area container:
    Item {
        id: topAreaContainer
        width: parent.width
        height: parent.height/2
        anchors.bottom: bottomAreaContainer.top

        // Home button:
        ImageButton {
            id: homeButton
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 8
            source: "qrc:/assets/ico-home.png"
            height: parent.height
            onClicked: homeClicked()
            visible: false
        }

        // Email button:
        ImageButton {
            id: emailButton
            anchors.bottom: parent.bottom
            anchors.left: homeButton.right
            anchors.leftMargin: 8
            source: "qrc:/assets/ico-email.png"
            height: parent.height
            onClicked: emailClicked()
            visible: false
        }

        // Coupon button:
        ImageButton {
            id: couponButton
            anchors.bottom: parent.bottom
            anchors.left: emailButton.right
            anchors.leftMargin: 8
            source: "qrc:/assets/ico-entercoupon.png"
            height: parent.height
            onClicked: couponClicked()
            visible: false
        }

        // Cart button:
        ImageButton {
            id: cartButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 8
            source: "qrc:/assets/ico-cart.png"
            height: parent.height
            onClicked: cartClicked()
            visible: false

            LargeBoldText {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -21
                anchors.verticalCenterOffset: -18
                color: _settings.ffGreen
                text: _cartModel.cartCount
                visible: _cartModel.cartCount > 0
            }
        }

        // Pig button:
        ImageButton {
            id: pigButton
            anchors.bottom: parent.bottom
            anchors.right: cartButton.visible ? cartButton.left : parent.right
            anchors.rightMargin: 8
            source: "qrc:/assets/ico-pig.png"
            height: parent.height
            onClicked: pigClicked()
            visible: false
        }
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

            // Footer central text:
            StandardText {
                id: footerCentralText
                color: _settings.ffWhite
                anchors.centerIn: parent
                visible: false
            }

            // Footer right text:
            StandardText {
                id: footerRightText
                color: _settings.ffWhite
                anchors.right: reservedArea.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                visible: false
            }

            // Reserved area:
            ReservedArea {
                id: reservedArea
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                height: parent.height
                width: height
                anchors.verticalCenter: parent.verticalCenter
                onReservedAreaClicked: {
                    privateNumericKeyPad.invoker = mainApplication
                    privateNumericKeyPad.state = "on"
                }
            }
        }
    }
}

