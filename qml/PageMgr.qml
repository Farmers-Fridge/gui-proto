import QtQuick 2.5
import QtQuick.Controls 1.4
import "pages"

Item {
    id: pageMgr
    property int elapsedTime: 0
    property variant pages: []
    property variant pageHistory: []
    property variant currentItem: undefined

    // Main timer (debug only):
    Timer {
        id: _mainTimer
        interval: 1000
        repeat: true
        running: pageMgr.enabled
        onTriggered: {
            elapsedTime += 1000
            if ((currentItem.idleTime > 0) && elapsedTime >= currentItem.idleTime)
            {
                currentItem.onIdleTimeOut()
                elapsedTime = 0
            }
        }

        // User active:
        function onUserActive()
        {
            elapsedTime = 0
        }

        Component.onCompleted: _eventWatcher.userActive.connect(onUserActive)
    }

    // Compare strings:
    function compareStrings(one, two)
    {
        return one.toLowerCase() === two.toLowerCase()
    }

    // Register pages:
    function registerPages()
    {
        var nChild = children.length
        for (var i=0; i<nChild; i++)
        {
            if (!children[i].isPage)
                continue
            pages.push(children[i].pageId)
        }
    }

    // Return true if page is registered:
    function pageRegistered(pageId)
    {
        for (var i=0; i<pages.length; i++)
        {
            if (compareStrings(pageId, pages[i]))
                return true
        }
        return false
    }

    // Load page:
    function loadPage(pageId)
    {
        // Page registered?
        if (!pageRegistered(pageId))
            return false
        if (currentItem && compareStrings(currentItem.pageId, pageId))
            return false
        var nChild = children.length
        for (var i=0; i<nChild; i++)
        {
            if (!children[i].isPage)
                continue
            if (compareStrings(pageId, children[i].pageId))
                currentItem = children[i]
            children[i].opacity = (compareStrings(pageId, children[i].pageId) ? 1 : 0)
        }
        return true
    }

    // Load page:
    function onLoadPage(pageId)
    {
        if (pageMgr.loadPage(pageId))
            historyPush(currentItem.pageId)
    }

    // Load previous page:
    function onLoadPreviousPage()
    {
        if (pageHistory.length > 1)
        {
            historyPop()
            mainWindow.logMessage("LOADING: ", pageHistory[pageHistory.length-1])
            pageMgr.loadPage(pageHistory[pageHistory.length-1])
        }
    }

    // User active:
    function onUserActive()
    {
        elapsedTime = 0
    }

    // Setup stock page:
    function setupStockPage()
    {
        stockPage.setup()
    }

    // History push:
    function historyPush(pageId)
    {
        pageHistory.push(pageId)
    }

    // History pop:
    function historyPop()
    {
        pageHistory.pop()
    }

    // Idle page:
    IdlePage {
        id: idlePage
    }

    // Menu page:
    MenuPage {
        id: menuPage
    }

    // Network page:
    NetworkPage {
        id: networkPage
    }

    // Stock page:
    StockPage {
        id: stockPage
    }

    // Load page:
    Component.onCompleted: {
        // Register pages:
        registerPages()

        // Load page, by id:
        mainApplication.loadPage.connect(onLoadPage)

        // Load previous page:
        mainApplication.loadPreviousPage.connect(onLoadPreviousPage)

        // User activity watcher:
        _eventWatcher.userActive.connect(onUserActive)

        // Load initial page:
        mainApplication.loadPage("_idlepage_")
    }

    /*
    Text {
        font.bold: true
        font.pixelSize: 48
        text: elapsedTime
        anchors.centerIn: parent
        z: _generalSettings.zMax
    }
    */
}
