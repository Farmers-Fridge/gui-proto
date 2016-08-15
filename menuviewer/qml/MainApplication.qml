import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0
import KeyBoard 1.0
import Commands 1.0
import "pages/menuviewer/idle"

Item {
    // Load path view:
    signal loadPathView()

    // Load grid view:
    signal loadGridView()

    // Set menu page mode:
    signal setMenuPageMode()

    // Show nutritional info:
    signal showNutritionalInfo()

    // Current stock item changed:
    signal currentStockItemChanged()

    // Add current item to cart:
    signal addCurrentItemToCart()

    // Identify current stock item by row/column:
    property int _currentStockItemRow: -1
    property int _currentStockItemCol: -1

    // Current view mode:
    property string _viewMode: "gridview"

    // App busy state:
    property bool _appIsBusy: false

    // Current workflow index:
    property int _currentWorkflowIndex: 0

    // Selected route:
    property string _selectedRoute: ""

    // Get category model source:
    function getCategoryModelSource()
    {
        var source = ""

        // Off line:
        if (_appData.offline_mode === "1")
        {
            // TO DO
            source = _controller.fromLocalFile(_controller.offLinePath + "/categories")
        }
        else
        // In line:
        {
            source = Utils.urlPlay(_appData.currentIP, _appData.categorySource)
        }

        return source
    }

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

    // OK clicked:
    function onOKClicked(enteredText)
    {   // User entered exit code:
        if (enteredText === _appData.exitCode)
            Qt.quit()
        else
        if (enteredText === _appData.stockCode)
        {
            mainApplication._selectedRoute = Utils.staticNoCacheOf(_appData.urlPublicRootValue, "/hosts.xml")
            pageMgr.loadPage("STOCK_NETWORK_PAGE")
            mainApplication.state = "active"
        }
        else
        if (enteredText === _appData.statsCode)
        {
            pageMgr.loadPage("STATS_INTRO_PAGE")
            mainApplication.state = "active"
        }
        privateNumericKeyPad.state = ""
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

    // Busy indicator:
    BusyIndicator {
        id: _busyIndicator
        anchors.centerIn: parent
        on: _appIsBusy
        visible: on
        z: _settings.zMax
    }

    // Idle page:
    IdlePage {
        id: idlePage
        anchors.fill: parent
        onIdlePageClicked: {
            pageMgr.loadFirstPage()
            mainApplication.state = "active"
        }
    }

    states: State {
        name: "active"
        PropertyChanges {
            target: idlePage
            opacity: 0
        }
    }

    // Set state back to grid view mode:
    onStateChanged: {
        if (state === "active") {
            _controller.currentCategory = _categoryModel.get(0).categoryName
            _viewMode = "gridview"
        }
    }
}

