import QtQuick 2.4

Popup {
    id: checkOutPopup
    popupId: "_checkout_"
    title: _settings.shoppingCartTitle

    contents: Item {
        width: parent.width
        height: parent.height

        // Header:
        Rectangle {
            id: header
            anchors.top: parent.top
            width: parent.width
            height: _settings.checkOutPopupHeaderHeight
            color: "brown"

            // First col:
            Item {
                id: firstCol
                width: parent.width/3
                height: parent.height
                CommonText {
                    anchors.centerIn: parent
                    text: qsTr("PRODUCT NAME")
                    color: "white"
                    font.pixelSize: 30
                }
            }

            // Second col:
            Item {
                id: secondCol
                width: parent.width/4
                height: parent.height
                anchors.left: firstCol.right
                CommonText {
                    anchors.centerIn: parent
                    text: qsTr("QUANTITY")
                    color: "white"
                    font.pixelSize: 30
                }
            }

            // Third col:
            Item {
                id: thirdCol
                width: parent.width*5/36
                height: parent.height
                anchors.left: secondCol.right
                CommonText {
                    anchors.centerIn: parent
                    text: qsTr("PRICE")
                    color: "white"
                    font.pixelSize: 30
                }
            }

            // Fourth col:
            Item {
                id: fourthCol
                width: parent.width*5/36
                height: parent.height
                anchors.left: thirdCol.right
                CommonText {
                    anchors.centerIn: parent
                    text: qsTr("TOTAL")
                    color: "white"
                    font.pixelSize: 30
                }
            }

            // Fifth col:
            Item {
                id: fifthCol
                width: parent.width*5/36
                height: parent.height
                anchors.left: fourthCol.right
                CommonText {
                    anchors.centerIn: parent
                    text: qsTr("ACTIONS")
                    color: "white"
                    font.pixelSize: 30
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
                font.pixelSize: 30
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

    // Cart count changed: if cart empty, close popup:
    function onCartCountChanged()
    {
        if (_controller.cartModel.cartCount < 1)
            checkOutPopup.state = ""
    }
    Component.onCompleted: _controller.cartModel.cartTotalChanged.connect(onCartCountChanged)
}

