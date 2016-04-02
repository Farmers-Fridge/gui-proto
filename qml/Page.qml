import QtQuick 2.5

Item {
    property string pageId
    property bool isPage: true
    property int idleTime: 0
    enabled: !_appIsBusy
    opacity: 0
    visible: opacity != 0

    // Resize:
    width: parent.width
    height: parent.height

    // Time out:
    function onIdleTimeOut()
    {
        // Base impl does nothing:
    }

    // Behavior on opacity:
    Behavior on opacity {
        NumberAnimation {duration: _settings.pageTransitionDelay}
    }
}

