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

    // Get page settings by id:
    function getPageSettingsById(pageId)
    {
        var pages = _appData.pages
        for (var i=0; i<pages.length; i++)
            if (pages[i].pageId === pageId)
                return pages[i]
        return null
    }

    // Get category model source:
    function getCategoryModelSource()
    {
        return _controller.fromLocalFile(_controller.offLinePath + "/categories.xml")
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
        if (enteredText === _appData.appCodes.exitCode) {
            _controller.saveSettings()
            Qt.quit()
        }
        else
        // User entered stock code:
        if (enteredText === _appData.appCodes.stockCode)
        {
            mainApplication._selectedRoute = Utils.staticNoCacheOf(_appData.urlPublicRootValue, "/hosts.xml")
            pageMgr.loadPage("STOCK_NETWORK_PAGE")
            mainApplication.state = "active"
        }
        else
        // User entered stats code:
        if (enteredText === _appData.appCodes.statsCode)
        {
            pageMgr.loadPage("STATS_INTRO_PAGE")
            mainApplication.state = "active"
        }
        else
        // User entered settings code:
        if (enteredText === _appData.appCodes.settingsCode)
        {
            pageMgr.loadPage("SETTINGS_PRESENTATION_PAGE")
            mainApplication.state = "active"
        }
        privateNumericKeyPad.state = ""
    }

    // Get image source:
    function getImageSource(targetCategory, imageUrl, isNutrition)
    {
        var extra = isNutrition ? "/nutrition/" : "/"
        return _controller.fromLocalFile(_controller.offLinePath + "/" + targetCategory + extra + _controller.fileBaseName(imageUrl))
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
            _controller.currentCategory = categoryModel.get(0).categoryName
            _viewMode = "gridview"
        }
    }
}

