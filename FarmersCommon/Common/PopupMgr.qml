import QtQuick 2.5
import Common 1.0

Item {
    id: popupMgr
    property bool popupOn: false
    property var callback

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
    function onShowPopup(popupId, callback)
    {
        popupMgr.callback = callback

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
    function onHidePopup(receiver, popupId)
    {
        callback("toto")
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
}

