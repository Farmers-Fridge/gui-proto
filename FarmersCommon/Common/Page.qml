import QtQuick 2.5

Rectangle {
    color: _settings.ffIvoryLight

    // Page id:
    property string pageId

    // Idle time out (5 secs):
    property int idleTimeOut: _settings.pageIdleTimeOut

    // Reserved area clicked:
    signal reservedAreaClicked()

    // Time out:
    function onIdleTimeOut()
    {
        //console.log("CALLING PAGE::ONIDLETIMEOUT")
    }

    // Initialize page:
    function initialize()
    {
        // Base impl does nothing:
        //console.log("INITIALIZING: ", pageId)
    }

    // Finalize page:
    function finalizePage()
    {
        // Base impl does nothing:
        //console.log("FINALIZING: ", pageID)
    }

    // Return next page id:
    function nextPageId()
    {
        return ""
    }

    // Is intial page?
    function isInitialPage()
    {
        return false
    }

    // Is final page?
    function isFinalPage()
    {
        return false
    }
}

