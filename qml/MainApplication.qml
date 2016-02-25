import QtQuick 2.4
import QtQml.Models 2.1
import QtQuick.Controls.Styles 1.2
import "commands"
import "./keyboard"

Item {
    id: mainApplication
    anchors.fill: parent

    // View state:
    property string viewState: ""

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

    // Delegate model:
    DelegateModel { id: albumVisualModel; model: _categoryModel; delegate: AlbumDelegate {} }

    // Header area:
    HeaderArea {
        id: headerArea
        anchors.top: parent.top
        width: parent.width
        height: _settings.menuViewTopAreaHeight
    }

    // Menu view area:
    Item {
        id: menuViewArea
        enabled: keyboard.state === ""
        width: parent.width
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom

        // Grid view:
        GridView {
            id: albumView; width: parent.width; height: parent.height; cellWidth: 210; cellHeight: 220
            model: albumVisualModel.parts.album; visible: albumsShade.opacity != 1.0
        }

        // Album shade:
        Rectangle {
            id: albumsShade; color: mainWindow.color
            width: parent.width; height: parent.height; opacity: 0.0
        }

        // Image browser:
        ListView { anchors.fill: parent; model: albumVisualModel.parts.browser; interactive: false }

        // Photo shade:
        Rectangle { id: photosShade; color: 'black'; width: parent.width; height: parent.height; opacity: 0; visible: opacity != 0.0 }

        // Listview:
        ListView {
            id: fullScreenListView
            anchors.fill: parent
            model: albumVisualModel.parts.fullscreen
            interactive: false
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
            visible: viewState !== ""
        }
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
        visible: _appIsBusy
    }
}

