import QtQuick 2.5

Popup {
    id: checkOutPopup
    popupId: "_checkoutpopup_"

    contents: Rectangle {
        id: container
        width: parent.width
        height: parent.height*3/4
        anchors.centerIn: parent
        color: _settings.popupBkgColor

        // Header (tax and total):
        Rectangle {
            width: parent.width/2
            height: _settings.checkOutPopupHeaderHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: container.top
            color: _settings.popupBkgColor
            border.color: _settings.green
            border.width: 3

            CommonText {
                anchors.centerIn: parent
                text: qsTr("Your Total: $") + _controller.cartModel.cartTotal
            }
        }

        // Cart view header:
        CartViewHeader {
            id: header
            anchors.top: parent.top
            width: parent.width
            height: _settings.checkOutPopupHeaderHeight
            color: "brown"
        }

        // View container:
        Item {
            id: viewContainer
            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: controlArea.top

            // Cart view:
            CartView {
                id: cartView
                anchors.fill: parent
            }
        }

        // Control area:
        Rectangle {
            id: controlArea
            width: parent.width
            height: _settings.checkOutPopupHeaderHeight
            anchors.bottom: parent.bottom
            color: "brown"

            Row {
                anchors.fill: parent
                Item {
                    width: parent.width/4
                    height: parent.height
                    CircularButton {
                        color: _settings.popupBkgColor
                        anchors.centerIn: parent
                        width: parent.height
                        source: "qrc:/qml/images/ico-cross.png"
                        onClicked: {
                            mainApplication.hidePopup("_checkoutpopup_")
                            _clearCartCommand.execute()
                            _controller.currentCategory = categoryModel.get(0).categoryName
                            mainApplication.setMenuPageMode("gridview")
                            mainApplication.loadPage("_idlepage_")
                        }
                    }
                }
                Item {
                    width: parent.width/4
                    height: parent.height
                    CircularButton {
                        color: _settings.popupBkgColor
                        anchors.centerIn: parent
                        width: parent.height
                        source: "qrc:/qml/images/ico-keep-shopping.png"
                        onClicked: mainApplication.hidePopup("_checkoutpopup_")
                    }
                }
                Item {
                    width: parent.width/4
                    height: parent.height
                    CircularButton {
                        color: _settings.popupBkgColor
                        anchors.centerIn: parent
                        width: parent.height
                        source: "qrc:/qml/images/ico-email.png"

                        // Keyboard enter key clicked:
                        function onKeyBoardEnterKeyClicked()
                        {
                            if (_controller.validateEmailAddress(mainApplication._keyboardText))
                            {
                                _takeReceiptEmailAddressCommand.emailAddress = mainApplication._keyboardText
                                _takeReceiptEmailAddressCommand.execute()
                            }

                            mainApplication.hideKeyBoard()

                            // Disconnect:
                            mainApplication.keyBoardEnterKeyClicked.disconnect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.disconnect(onKeyBoardCancelKeyClicked)
                        }

                        // Keyboard cancel key clicked:
                        function onKeyBoardCancelKeyClicked()
                        {
                            mainApplication.hideKeyBoard()

                            // Disconnect:
                            mainApplication.keyBoardEnterKeyClicked.disconnect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.disconnect(onKeyBoardCancelKeyClicked)
                        }

                        onClicked: {
                            mainApplication.keyBoardEnterKeyClicked.connect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.connect(onKeyBoardCancelKeyClicked)
                            mainApplication.showKeyBoard()
                        }
                    }
                }
                Item {
                    width: parent.width/4
                    height: parent.height
                    CircularButton {
                        color: _settings.popupBkgColor
                        anchors.centerIn: parent
                        width: parent.height
                        source: "qrc:/qml/images/ico-entercoupon.png"

                        // Keyboard enter key clicked:
                        function onKeyBoardEnterKeyClicked()
                        {
                            if (mainApplication._keyboardText.length > 0)
                            {
                                _takeCouponCodeCommand.couponCode = mainApplication._keyboardText
                                _takeCouponCodeCommand.execute()
                            }

                            mainApplication.hideKeyBoard()

                            // Disconnect:
                            mainApplication.keyBoardEnterKeyClicked.disconnect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.disconnect(onKeyBoardCancelKeyClicked)
                        }

                        // Keyboard enter cancel key clicked:
                        function onKeyBoardCancelKeyClicked()
                        {
                            mainApplication.hideKeyBoard()

                            // Disconnect:
                            mainApplication.keyBoardEnterKeyClicked.disconnect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.disconnect(onKeyBoardCancelKeyClicked)
                        }

                        onClicked: {
                            mainApplication.keyBoardEnterKeyClicked.connect(onKeyBoardEnterKeyClicked)
                            mainApplication.keyBoardCancelKeyClicked.connect(onKeyBoardCancelKeyClicked)
                            mainApplication.showKeyBoard()
                        }
                    }
                }
            }
        }
    }

    // Cart count changed: if cart empty, close popup:
    function onCartCountChanged()
    {
        if (_controller.cartModel.cartCount < 1)
            mainApplication.hidePopup("_checkoutpopup_")
    }
    Component.onCompleted: _controller.cartModel.cartTotalChanged.connect(onCartCountChanged)
}

