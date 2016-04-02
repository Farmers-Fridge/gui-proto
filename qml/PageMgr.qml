import QtQuick 2.5
import QtQuick.Controls 1.2

Item {
    id: pageMgr
    property int elapsedTime: 0
    property string previousPage: "_first_"
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

    // Idle page:
    IdlePage {
        id: idlePage
    }

    // First page:
    FirstPage {
        id: firstPage
    }

    // Load page:
    function onLoadPage(pageId)
    {
        var nChild = children.length
        for (var i=0; i<nChild; i++)
        {
            if (!children[i].isPage)
                continue
            if (pageId === children[i].pageId)
                currentItem = children[i]
            children[i].opacity = (pageId === children[i].pageId ? 1 : 0)
        }
    }

    // User active:
    function onUserActive()
    {
        elapsedTime = 0
    }

    // Load page:
    Component.onCompleted: {
        // Page navigation:
        mainApplication.loadPage.connect(onLoadPage)

        /*
        mainApplication.goBack.connect(onGoBack)
        mainApplication.popPage.connect(onPopPage)
        */

        // User activity watcher:
        _eventWatcher.userActive.connect(onUserActive)

        // Load initial page:
        onLoadPage("_idle_")
    }
}
