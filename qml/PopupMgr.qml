import QtQuick 2.4
import "script/Utils.js" as Utils

Item {
    id: popupMgr
    property variant currentPopup: undefined

    // On show popup:
    function onShowPopup(popupId)
    {
        currentPopup = undefined
        for (var i=0; i<children.length; i++)
        {
            var child = children[i]
            if (!child.isPopup)
                continue
            if (Utils.stringCompare(popupId, child.popupId))
            {
                currentPopup = child
                child.state = "on"
            }
        }
    }

    // Hide current popup:
    function onHideCurrentPopup()
    {
        if (currentPopup)
            currentPopup.state = ""
    }

    Component.onCompleted: {
        mainApplication.showPopup.connect(onShowPopup)
        mainApplication.hideCurrentPopup.connect(onHideCurrentPopup)
    }
}

