import QtQuick 2.5
import QtQml.Models 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import "script/Utils.js" as Utils
import "commands"
import "./keyboard"

Item {
    id: mainApplication
    anchors.fill: parent

    // Background decoration:
    Background {
        anchors.fill: parent
        color: _settings.mainWindowColor
    }

    // Notepad text:
    property string _notePadText: ""

    // Application busy state:
    property bool _appIsBusy: false

    // Identify current stock item by row/column:
    property int _currentStockItemRow: -1
    property int _currentStockItemCol: -1

    // Load popup:
    signal showPopup(string popupId)

    // Hide popup:
    signal hidePopup(string popupId)

    // Navigate left:
    signal navigateLeft()

    // Navigate right:
    signal navigateRight()

    // Load page:
    signal loadPage(string pageId)

    // Load previous page:
    signal loadPreviousPage()

    // Model ready:
    signal modelReady()

    // Load grid view:
    signal loadGridView()

    // Load path view:
    signal loadPathView()

    // Show keypad:
    signal showKeyPad()

    // Hide keypad:
    signal hideKeyPad()

    // Show notepad:
    signal showNodePad()

    // Hide notepad:
    signal hideNotePad()

    // Show stock keypad:
    signal showStockKeyPad(int theoPar, int actualPar)

    // Hide stock keypad:
    signal hideStockKeyPad()

    // Notepad enter key clicked:
    signal notePadEnterClicked()

    // Notepad cancel key clicked:
    signal notePadCancelKeyClicked()

    // Keypad enter key clicked:
    signal keyPadEnterKeyClicked(string text)

    // Keypad cancel key clicked:
    signal keyPadCancelKeyClicked()

    // Stock keypad enter key clicked:
    signal stockKeyPadEnterKeyClicked(string text)

    // Stock leypad cancel key clicked:
    signal stockKeyPadCancelKeyClicked()

    // Set menu page mode:
    signal setMenuPageMode(string mode)

    // Current stock item changed:
    signal currentStockItemChanged()

    // Set current stock item:
    function setCurrentStockItem(rowNumber, columnNumber)
    {
        if ((rowNumber > 0) && (columnNumber > 0))
        {
            _currentStockItemRow = rowNumber
            _currentStockItemCol = columnNumber
            currentStockItemChanged()
        }
    }

    // Settings:
    Settings {
        id: _settings
    }

    // Colors:
    Colors {
        id: _colors
    }

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

    // Restock from tablet command:
    RestockFromTabletCommand {
        id: _restockFromTabletCommand
    }

    // Update restock exception command:
    UpdateRestockExceptionCommand {
        id: _updateRestockExceptionCommand
    }

    // Clear all command:
    ClearAllCommand {
        id: _clearAllCommand
    }

    // Commands:
    ExitCommand {
        id: _exitCommand
    }

    // XML version model:
    CustomXmlListModel {
        id: categoryModel
        source: Utils.urlPlay(_appData.currentIP, _appData.categorySource)
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
                    mainApplication.modelReady()
                }
            }
        }
    }

    // Page mgr:
    PageMgr {
        id: _pageMgr
        anchors.fill: parent
        enabled: !_popupMgr.popupOn &&
            (_keyPadPopup.state === "") &&
                 (_notePadPopup.state === "") &&
                    (_stockKeyPadPopup.state === "")
    }

    // Popup mgr:
    PopupMgr {
        id: _popupMgr
        anchors.fill: parent
        enabled: (_keyPadPopup.state === "") && (_notePadPopup.state === "")

        // Check out popup:
        CheckOutPopup {
            width: parent.width
            height: parent.height
        }
    }

    // Numeric key pad:
    KeyPadPopup {
        id: _keyPadPopup
        width: parent.width
        height: parent.height
    }

    // Stock numeric key pad:
    StockKeyPadPopup {
        id: _stockKeyPadPopup
        width: parent.width
        height: parent.height
    }

    // Nodepad popup:
    NodePadPopup {
        id: _notePadPopup
        width: parent.width
        height: parent.height
    }

    // Busy indicator:
    BusyIndicator {
        id: _busyIndicator
        anchors.centerIn: parent
        on: _appIsBusy
        visible: on
    }
}

