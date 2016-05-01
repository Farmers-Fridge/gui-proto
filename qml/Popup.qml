import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    id: popup
    property string popupId: ""
    property bool isPopup: true
    property int idleTime: 0
    property alias contents: contents.children
    y: Screen.desktopAvailableHeight+40

    // Border:
    Item {
        id: contents
        anchors.fill: parent
    }

    // Reset:
    function reset()
    {
        // Base impl does nothing:
    }

    // Time out:
    function onIdleTimeOut()
    {
        // Base impl does nothing:
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: popup
            y: 0
        }
    }

    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: _timeSettings.widgetAnimationDuration; spring: 3; damping: 0.2}
    }
}
