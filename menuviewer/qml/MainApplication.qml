import QtQuick 2.5
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
            mainApplication._selectedRoute = Utils.staticNoCacheOf(_appData.serverInfo.urlForStock, "/hosts.xml")
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
        if (targetCategory.length > 0)
        {
            if (isNutrition) {
                console.log("GETTING IMAGE SOURCE FOR: ", targetCategory, imageUrl, isNutrition)
            }
            var extra = isNutrition ? "/nutrition/" : "/"
            return _controller.fromLocalFile(_controller.offLinePath + "/" + targetCategory + extra + _controller.fileBaseName(imageUrl))
        }
        return ""
    }

    // Add to cart command:
    AddToCartCommand {
        id: _addToCartCommand
        onAddItem: _controller.addItem(vendItemName, icon, nutrition, category, price)
    }

    // Update restock exception command:
    UpdateRestockExceptionCommand {
        id: _updateRestockExceptionCommand
        // TO DO: WHICH URL TO USE HERE?
        //_url: getPageSettingsById("STOCK_PRESENTATION_PAGE").stockPageIP
    }

    // Clear all command:
    ClearAllCommand {
        id: _clearAllCommand
    }

    // Restock from tablet command:
    RestockFromTabletCommand {
        id: _restockFromTabletCommand
        _url: getPageSettingsById("STOCK_PRESENTATION_PAGE").stockPageIP
        _contentType: "application/json"
    }

    // Take coupon command:
    TakeCouponCommand {
        id: _takeCouponCodeCommand
        _url: _appData.serverInfo.ipForTakeCouponAndTakeReceiptEmailAddress
    }

    // Take receipt email address command:
    TakeReceiptEmailAddressCommand {
        id: _takeReceiptEmailAddressCommand
        _url: _appData.serverInfo.ipForTakeCouponAndTakeReceiptEmailAddress
    }

    // Phone command:
    PhoneCommand {
        id: _phoneCommand
        // TO DO: is this correct?
        _url: _appData.serverInfo.ipForTakeCouponAndTakeReceiptEmailAddress
    }

    // Page mgr:
    PageMgr {
        id: pageMgr
        anchors.fill: parent
        pages: _appData.pages
        enabled: (privateNumericKeyPad.state === "") &&
                 (stockNumericKeyPad.state === "") &&
                 (notepad.state === "") &&
                 (signInDialog.state === "") &&
                 (registerDialog.state === "") &&
                 (cartSummaryDialog.state === "")
        Component.onCompleted: initialize()
        onCurrentPageIdChanged: {
            if (currentPageId === "IDLE_PAGE")
            {
                privateNumericKeyPad.state = ""
                stockNumericKeyPad.state = ""
                notepad.state = ""
                signInDialog.state = ""
                registerDialog.state = ""
                cartSummaryDialog.state = ""
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

    // Signin dialog:
    SignInDialog {
        id: signInDialog
        anchors.centerIn: parent
        z: _settings.zMax
    }

    // Register dialog:
    RegisterDialog {
        id: registerDialog
        anchors.centerIn: parent
        z: _settings.zMax
    }

    // Cart summary dialog:
    CartSummaryDialog {
        id: cartSummaryDialog
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
}

