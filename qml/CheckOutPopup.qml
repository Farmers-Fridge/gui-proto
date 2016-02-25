import QtQuick 2.4

Popup {
    id: popup
    popupId: "_checkout_"
    title: _settings.shoppingCartTitle

    contents: Item {
        anchors.fill: parent

        // Header:
        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: _settings.checkOutPopupHeaderHeight
            color: "brown"
            CommonText {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Recently Added Items")
                color: "white"
            }
            ImageButton {
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-clear.png"
                width: parent.height
                onClicked: {
                    _clearCartCommand.execute()
                    popup.state = ""
                }
            }
        }

        // View container:
        Item {
            id: viewContainer
            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: totalArea.top

            // Cart view:
            CartView {
                id: cartView
                anchors.fill: parent
            }
        }

        // Total area:
        Rectangle {
            id: totalArea
            width: parent.width
            height: _settings.checkOutPopupHeaderHeight
            anchors.bottom: parent.bottom
            color: "brown"
            CommonText {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: "Total: $" + _controller.cartModel.cartTotal
                color: "white"
            }

            // Email:
            ImageButton {
                id: emailButton
                height: parent.height-8
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-email.png"
                onClicked: {
                    keyboard.enterClicked.connect(onEnterClicked)
                    mainApplication.showKeyBoard()
                }

                // Enter clicked:
                function onEnterClicked()
                {
                    // Setup takeReceiptEmailAddressCommand:
                    if (_controller.validateEmailAddress(_keyboardText))
                    {
                        _takeReceiptEmailAddressCommand.emailAddress = _keyboardText
                        _takeReceiptEmailAddressCommand.execute()
                    }
                    else console.log(_keyboardText + " IS NOT A VALID EMAIL ADDRESS")
                    keyboard.enterClicked.disconnect(onEnterClicked)
                }
            }

            // Take receipt email address command:
            ImageButton {
                id: enterCouponButton
                anchors.right: emailButton.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                width: parent.height
                source: "qrc:/qml/images/ico-entercoupon.png"
                onClicked: {
                    keyboard.enterClicked.connect(onEnterClicked)
                    mainApplication.showKeyBoard()
                }

                // Enter clicked:
                function onEnterClicked()
                {
                    // Setup takeCouponCodeCommand:
                    if (_controller.validateCoupon(_keyboardText))
                    {
                        _takeCouponCodeCommand.couponCode = _keyboardText
                        _takeCouponCodeCommand.execute()
                    }
                    else console.log(_keyboardText + " IS NOT A VALID COUPON")
                    keyboard.enterClicked.disconnect(onEnterClicked)
                }
            }
        }
    }
}

