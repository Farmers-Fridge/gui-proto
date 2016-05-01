import QtQuick 2.5

Item {
    property string pageId: ""
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
        NumberAnimation {duration: _timeSettings.pageTransitionDuration}
    }

    // Key pad enter clicked:
    function onKeyPadEnterKeyClicked(text)
    {
        mainApplication.hideKeyPad()

        // User entered exit code:
        if (text === _appData.exitCode)
            _exitCommand.execute()
        else
        if (text === _appData.tabletGuiCode)
            mainApplication.loadPage("_networkpage_")

        // Disconnect:
        mainApplication.keyPadEnterKeyClicked.disconnect(onKeyPadEnterKeyClicked)
        mainApplication.keyPadCancelKeyClicked.disconnect(onKeyPadCancelKeyClicked)
    }

    // Key pad cancel clicked:
    function onKeyPadCancelKeyClicked(text)
    {
        mainApplication.hideKeyPad()

        // Disconnect:
        mainApplication.keyPadEnterKeyClicked.disconnect(onKeyPadEnterKeyClicked)
        mainApplication.keyPadCancelKeyClicked.disconnect(onKeyPadCancelKeyClicked)
    }

    // Hidden area:
    MouseArea {
        id: hiddenArea
        width: 96
        height: 96
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        z: _generalSettings.zMax

        onClicked: {
            mainApplication.keyPadEnterKeyClicked.connect(onKeyPadEnterKeyClicked)
            mainApplication.keyPadCancelKeyClicked.connect(onKeyPadCancelKeyClicked)
            mainApplication.showKeyPad()
        }
    }
}

