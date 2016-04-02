import QtQuick 2.5
import "script/Utils.js" as Utils

Item {
    id: popupMgr
    property bool popupOn: false

    // Check visible popups:
    function checkVisiblePopups()
    {
        popupOn = false
        for (var i=0; i<children.length; i++)
        {
            var child = children[i]
            if (!child.isPopup)
                continue
            if (child.state === "on")
                popupOn = true
        }
    }

    // On show popup:
    function onShowPopup(popupId)
    {
        for (var i=0; i<children.length; i++)
        {
            var child = children[i]
            if (!child.isPopup)
                continue
            if (Utils.stringCompare(popupId, child.popupId))
            {
                child.reset()
                child.state = "on"
                break
            }
        }
        checkVisiblePopups()
    }

    // Hide popup:
    function onHidePopup(popupId)
    {
        for (var i=0; i<children.length; i++)
        {
            var child = children[i]
            if (!child.isPopup)
                continue
            if (Utils.stringCompare(popupId, child.popupId))
            {
                child.state = ""
                break
            }
        }
        checkVisiblePopups()
    }

    Component.onCompleted: {
        mainApplication.showPopup.connect(onShowPopup)
        mainApplication.hidePopup.connect(onHidePopup)
    }
}

