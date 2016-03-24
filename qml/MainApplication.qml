import QtQuick 2.4
import QtQml.Models 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import "commands"
import "./keyboard"

Rectangle {
    id: mainApplication
    anchors.fill: parent
    color: "#dad7c4"

    // View state:
    property string _viewState: ""

    // Keyboard text:
    property string _keyboardText: ""

    // Application busy state:
    property bool _appIsBusy: false

    // Load popup:
    signal showPopup(string popupId)

    // Hide current popup:
    signal hideCurrentPopup()

    // Show keyboard:
    signal showKeyBoard()

    // Hide keyboard:
    signal hideKeyBoard()

    // Navigate left:
    signal navigateLeft()

    // Navigate right:
    signal navigateRight()

    // Go back to main page:
    signal goBackToMainPage()

    // Add current item:
    signal addCurrentItem()

    // Check out command:
    CheckOutCommand {
        id: _checkOutCommand
    }

    // Add to cart command:
    AddToCartCommand {
        id: _addToCartCommand
    }

    // Clear cart command:
    ClearCartCommand {
        id: _clearCartCommand
    }

    // Take receipt email address command:
    TakeReceiptEmailAddressCommand {
        id: _takeReceiptEmailAddressCommand
    }

    // Take coupon command:
    TakeCouponCommand {
        id: _takeCouponCodeCommand
    }

    // Commands:
    ExitCommand {
        id: _exitCommand
    }

    // Update browser view:
    function updateBrowserView(index)
    {
        browserView.positionViewAtIndex(index, ListView.Beginning)
    }

    // Delegate model:
    DelegateModel { id: albumVisualModel; model: _categoryModel; delegate: MenuDelegate {} }

    // Primary header area:
    PrimaryHeaderArea {
        id: categoryView
        anchors.top: parent.top
        width: parent.width
        height: _settings.toolbarHeightRatio*parent.height
    }

    // Menu view area:
    Rectangle {
        id: menuViewArea
        color: "black"
        enabled: keyboard.state === ""
        width: parent.width
        anchors.top: categoryView.bottom
        anchors.bottom: primaryBottomArea.top

        // Image browser:
        ListView {
            id: browserView
            anchors.fill: parent
            model: albumVisualModel.parts.browser
            interactive: false
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
        }

        // Photo shade:
        Rectangle { id: photosShade
            color: "black"; width: parent.width; height: parent.height; opacity: 0; visible: opacity != 0.0
            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }

        // Listview:
        ListView {
            id: fullScreenListView
            anchors.fill: parent
            model: albumVisualModel.parts.fullscreen
            interactive: false
        }

        Item {
            anchors.fill: menuViewArea
            visible: _viewState === "fullscreen"

            // Previous button:
            CircularButton {
                anchors.bottom: returnToSaladsButton.top
                anchors.bottomMargin: 48
                anchors.horizontalCenter: returnToSaladsButton.horizontalCenter
                source: "qrc:/qml/images/ico-prev.png"
                onClicked: navigateLeft()
                imageOffset: -8
            }

            // Return to salads:
            TextClickButton {
                id: returnToSaladsButton
                text: _settings.returnToSaladsText
                width: _settings.buttonWidth*1.75
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 48
                onButtonClicked: mainApplication.goBackToMainPage()
            }

            // Next button:
            CircularButton {
                anchors.bottom: addTocartButton.top
                anchors.bottomMargin: 48
                anchors.horizontalCenter: addTocartButton.horizontalCenter
                source: "qrc:/qml/images/ico-next.png"
                onClicked: navigateRight()
                imageOffset: 8
            }

            // Add to cart:
            TextClickButton {
                id: addTocartButton
                text: _settings.addToCartText
                width: _settings.buttonWidth*1.75
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 48
                onButtonClicked: mainApplication.addCurrentItem()
            }
        }

        // Foreground:
        Item { id: foreground; anchors.fill: parent }
    }

    // Bottom area:
    BottomArea {
        id: primaryBottomArea
        width: parent.width
        height: _settings.toolbarHeightRatio*parent.height
        anchors.bottom: parent.bottom
    }

    // Popup mgr:
    PopupMgr {
        anchors.fill: parent
        enabled: keyboard.state === ""

        // Check out popup:
        CheckOutPopup {
            width: parent.width
            height: parent.height
        }
    }

    // Keyboard:
    KeyBoard {
        id: keyboard
        anchors.centerIn: parent
        onEnterClicked: {
            _keyboardText = text
            hideKeyBoard()
        }
    }

    // Busy indicator:
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        on: _appIsBusy
        visible: on
    }
}

