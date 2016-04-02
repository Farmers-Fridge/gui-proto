import QtQuick 2.5
import QtQml.Models 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import "script/Utils.js" as Utils
import "commands"
import "./keyboard"

Rectangle {
    id: mainApplication
    anchors.fill: parent
    color: "#dad7c4"

    // Keyboard text:
    property string _keyboardText: ""

    // Application busy state:
    property bool _appIsBusy: false

    // Load popup:
    signal showPopup(string popupId)

    // Hide popup:
    signal hidePopup(string popupId)

    // Navigate left:
    signal navigateLeft()

    // Navigate right:
    signal navigateRight()

    // Go back to main page:
    signal goBackToMainPage()

    // Load page:
    signal loadPage(string pageId)

    // Model ready:
    signal modelReady()

    // Load grid view:
    signal loadGridView()

    // Load path view:
    signal loadPathView()

    // Show keypad:
    signal showKeyPad()

    // Show keyboard:
    signal showKeyBoard()

    // Keyboard enter key clicked:
    signal keyboardEnterKeyClicked()

    // Set first page mode:
    signal setFirstPageMode(string mode)

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

    // XML version model:
    XmlListModel {
        id: categoryModel
        source: Utils.urlPlay(_appData.categorySource)
        query: _appData.categoryQuery

        XmlRole { name: "categoryName"; query: "categoryName/string()"; isKey: true }
        XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
        XmlRole { name: "header"; query: "header/string()"; isKey: true }

        onStatusChanged: {
            // Load main application:
            if (status !== XmlListModel.Loading)
            {
                // Error:
                if (status === XmlListModel.Error)
                {
                    // Log:
                    console.log("Can't load: " + source)
                }
                else
                // Model ready:
                if (status === XmlListModel.Ready)
                {
                    // Set current category name:
                    _controller.currentCategory = categoryModel.get(0).categoryName

                    // Set category model:
                    _categoryModel = categoryModel

                    // Log:
                    console.log(source + " loaded successfully")

                    // Notify:
                    modelReady()
                }
            }
        }
    }

    // Page mgr:
    PageMgr {
        id: _pageMgr
        anchors.fill: parent
        enabled: !_popupMgr.popupOn &&
            (_numericKeyPadPopup.state === "") && (_keyboardPopup.state === "")
    }

    // Popup mgr:
    PopupMgr {
        id: _popupMgr
        anchors.fill: parent
        enabled: (_numericKeyPadPopup.state === "") && (_keyboardPopup.state === "")

        // Check out popup:
        CheckOutPopup {
            width: parent.width
            height: parent.height
        }
    }

    // Numeric key pad:
    NumericKeyPadPopup {
        id: _numericKeyPadPopup
        width: parent.width
        height: parent.height
    }

    // Keyboard popup:
    KeyBoardPopup {
        id: _keyboardPopup
        width: parent.width
        height: parent.height
    }

    // Busy indicator:
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        on: _appIsBusy
        visible: on
    }
}

