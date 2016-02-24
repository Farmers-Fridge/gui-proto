import QtQuick 2.4

Item {
    property string popupId: ""
    property bool isPopup: true
    property int idleTime: 0

    // Background color:
    Rectangle {
        anchors.fill: parent
        color: _settings.popupBkgColor
    }

    // Time out:
    function onIdleTimeOut()
    {
        // Base impl does nothing:
    }
}
