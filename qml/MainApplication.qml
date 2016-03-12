import QtQuick 2.4
import QtQml.Models 2.1
import QtQuick.Controls.Styles 1.2
import "commands"
import "./keyboard"

Item {
    id: mainApplication
    anchors.fill: parent

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
        id: primaryHeaderArea
        anchors.top: parent.top
        width: parent.width
        height: _settings.toolbarHeightRatio*parent.height
    }

    // Secondary header area:
    SecondaryHeaderArea {
        id: secondaryHeaderArea
        anchors.top: primaryHeaderArea.bottom
        width: parent.width
        height: _settings.toolbarHeightRatio*parent.height
    }

    // Third header area:
    ThirdHeaderArea {
        id: thirdHeaderArea
        anchors.top: secondaryHeaderArea.bottom
        width: parent.width
        height: _settings.toolbarHeightRatio*parent.height
    }

    // Menu view area:
    Item {
        id: menuViewArea
        enabled: keyboard.state === ""
        width: parent.width
        anchors.top: thirdHeaderArea.bottom
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

        Rectangle {
            color: "transparent"
            border.color: _settings.appGreen
            border.width: 3
            anchors.fill: fullScreenListView
            visible: _viewState === "fullscreen"

            // Navigate left:
            ImageButton {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-left.png"
                onClicked: navigateLeft()
            }

            // Navigate right:
            ImageButton {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-right.png"
                onClicked: navigateRight()
            }
        }

        // Foreground:
        Item { id: foreground; anchors.fill: parent }

        // Back button:
        ImageButton {
            id: backButton
            source: "qrc:/qml/images/ico-back.png"
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            visible: _viewState !== "inGrid"
            onClicked: menuWrapper.state = "inGrid"
        }
    }

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

