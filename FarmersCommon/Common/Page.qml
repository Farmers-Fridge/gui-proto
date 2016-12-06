import QtQuick 2.5

Rectangle {
    color: _colors.ffColor2

    // Page id:
    property string pageId

    // Idle time out (5 secs):
    property int idleTimeOut: _settings.pageIdleTimeOut

    // Reserved area clicked:
    signal reservedAreaClicked()

    // Time out:
    function onIdleTimeOut()
    {
        _pageMgr.loadFirstPage()
    }

    // Initialize page:
    function initialize()
    {
        // Base impl does nothing:
        //console.log("INITIALIZING: ", pageId)
    }

    // Finalize page:
    function finalize()
    {
        // Base impl does nothing:
        //console.log("FINALIZING: ", pageID)
    }

    // Return next page id:
    function nextPageId()
    {
        return ""
    }
}

