import QtQuick 2.5

Item {
    property string pageId

    // Background:
    Image {
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "qrc:/icons/ico-background.png"
    }

    // Initialize page:
    function initialize()
    {
        // Base impl does nothing:
        console.log("INITIALIZING: ", pageId)
    }

    // Finalize page:
    function finalizePage()
    {
        // Base impl does nothing:
        console.log("FINALIZING: ", pageID)
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

