import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0
import KeyBoard 1.0
import Commands 1.0

Item {
    // Load path view:
    signal loadPathView()

    // Load grid view:
    signal loadGridView()

    // Set menu page mode:
    signal setMenuPageMode()

    // Navigate left:
    signal navigateLeft()

    // Navigate right:
    signal navigateRight()

    // Add current item to cart:
    signal addCurrentItemToCart()

    // Show nutritional info:
    signal showNutritionalInfo()

    // Current stock item changed:
    signal currentStockItemChanged()

    // Identify current stock item by row/column:
    property int _currentStockItemRow: -1
    property int _currentStockItemCol: -1

    // App busy state:
    property bool _appIsBusy: false

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

    // Add to cart command:
    AddToCartCommand {
        id: _addToCartCommand
        onAddItem: _controller.addItem(vendItemName, icon, nutrition, category, price)
    }

    // Update restock exception command:
    UpdateRestockExceptionCommand {
        id: _updateRestockExceptionCommand
    }

    // Clear all command:
    ClearAllCommand {
        id: _clearAllCommand
    }

    // Restock from tablet command:
    RestockFromTabletCommand {
        id: _restockFromTabletCommand
        _networkIP: _controller.currentNetworkIP
    }

    // Take coupon command:
    TakeCouponCommand {
        id: _takeCouponCodeCommand
        _networkIP: _appData.currentIP
    }

    // Take receipt email address command:
    TakeReceiptEmailAddressCommand {
        id: _takeReceiptEmailAddressCommand
        _networkIP: _appData.currentIP
    }

    // Page mgr:
    PageMgr {
        id: pageMgr
        anchors.fill: parent
        pages: _appData.pages
        enabled: (privateNumericKeyPad.state === "") &&
            (stockNumericKeyPad.state === "") &&
                 (notepad.state === "")
    }

    // Get category model source:
    function getCategoryModelSource()
    {
        var source = ""

        // Off line:
        if (_appData.offline_mode === "1")
        {
            // TO DO
            source = "file:///" + _controller.offLinePath + "/categories"
        }
        else
        // In line:
        {
            source = Utils.urlPlay(_appData.currentIP, _appData.categorySource)
        }

        return source
    }

    // XML version model:
    CustomXmlListModel {
        id: categoryModel
        source: getCategoryModelSource()
        query: _appData.categoryQuery

        XmlRole { name: "categoryName"; query: "categoryName/string()"; isKey: true }
        XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
        XmlRole { name: "header"; query: "header/string()"; isKey: true }

        onStatusChanged: {
            _appIsBusy = (status === XmlListModel.Loading)

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

                    // Load first page:
                    pageMgr.initialize()
                }
            }
        }
    }

    // OK clicked:
    function onOKClicked(enteredText)
    {   // User entered exit code:
        if (enteredText === _appData.exitCode)
            Qt.quit()
        else
        if (enteredText === _appData.tabletGuiCode)
            pageMgr.loadPage("NETWORK_PAGE")
        privateNumericKeyPad.state = ""
    }

    // Numeric keypad:
    NumericKeyPad {
        id: privateNumericKeyPad
        anchors.centerIn: parent
        z: _settings.zMax
    }

    // Stock numeric keypad:
    StockNumericKeyPad {
        id: stockNumericKeyPad
        anchors.centerIn: parent
        z: _settings.zMax
    }

    // Notepad:
    NotePad {
        id: notepad
        anchors.centerIn: parent
        z: _settings.zMax
    }

    // Reserved area:
    ReservedArea {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: (_settings.footerRatio/2)*parent.height
        width: height
        z: _settings.zMax
        onReservedAreaClicked: {
            privateNumericKeyPad.invoker = mainApplication
            privateNumericKeyPad.state = "on"
        }
    }

    // Busy indicator:
    BusyIndicator {
        id: _busyIndicator
        anchors.centerIn: parent
        on: _appIsBusy
        visible: on
        z: _settings.zMax
    }
}

