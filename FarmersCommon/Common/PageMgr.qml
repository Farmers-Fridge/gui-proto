import QtQuick 2.5
import QtQuick.Controls 1.2

StackView {
    id: pageMgr
	
	// Pages:
	property variant pages: []

    // Measurement of elapsed time:
    property int elapsedTime: 0

	// Public interface:
	signal loadFirstPage()
	signal loadNextPage()
	signal loadPreviousPage()

    // Main timer (debug only):
    Timer {
        id: mainTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            elapsedTime += 1000
            if ((currentItem.idleTimeOut > 0) && elapsedTime >= currentItem.idleTimeOut)
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

    // Create page:
    function createPage(pageId)
    {
        // Get page description:
        var pageDesc = getPageDesc(pageId)
        if (!pageDesc)
            return null

        // Create a new page component:
        var component = Qt.createComponent(pageDesc.url)
        if (!component)
            return null

        // Create page:
        var page = component.createObject()
        if (!page)
        {
            console.log("CREATEPAGE ERROR: ", component.errorString())
            return null
        }

        // Set object name:
        page.pageId = pageDesc.pageId

        // Initialize page:
        page.initialize()

        return page
    }

    // Get page desc given a page id:
    function getPageDesc(pageId)
    {
        var nPages = pages.length
        for (var i=0; i<nPages; i++)
        {
            var pageDesc = pages[i]
            if (pageDesc.pageId === pageId)
                return pageDesc
        }
        return null
    }

    // Load next page:
    function onLoadNextPage()
    {
        if (currentItem)
        {
            console.log("REQUEST TO LOAD: ", currentItem.nextPageId())
            var nextPage = createPage(currentItem.nextPageId())
            if (nextPage)
                push(nextPage)
        }
    }

    // Load previous page:
    function onLoadPreviousPage()
    {
        pop()
    }

    // Load first page:
    function onLoadFirstPage()
    {
        pop(get(0))
    }

    Component.onCompleted: {
        if (pages.length > 0)
        {
            var page = createPage(pages[0].pageId)
            if (page)
                push(page)

			loadFirstPage.connect(onLoadFirstPage)
            loadPreviousPage.connect(onLoadPreviousPage)
            loadNextPage.connect(onLoadNextPage)
        }
    }
}
