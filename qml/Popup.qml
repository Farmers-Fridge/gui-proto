import QtQuick 2.4

Item {
    id: popup
    property string popupId: ""
    property bool isPopup: true
    property int idleTime: 0
    property alias contents: contents.children
    y: height

    // Background color:
    Rectangle {
        anchors.fill: parent
        color: _settings.popupBkgColor
    }

    // Border:
    Item {
        id: contents
        anchors.fill: parent
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
        SpringAnimation {target: popup; property: "y"; duration: 500; spring: 3; damping: 0.2}
    }
}
