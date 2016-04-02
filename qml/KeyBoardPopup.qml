import QtQuick 2.5
import "keyboard"
import QtQuick.Window 2.0

Popup {
    id: keyboardPopup
    popupId: "_keyboard_"
    y: Screen.desktopAvailableHeight+40

    contents: KeyBoard {
        id: keyboard
        anchors.centerIn: parent
        onEnterClicked: {
            _keyboardText = text
            mainApplication.keyboardEnterKeyClicked()
            keyboardPopup.state = ""
        }
    }

    // States:
    states: State {
        name: "on"
        PropertyChanges {
            target: checkOutPopup
            y: 0
        }
    }

    // Transition:
    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: _settings.pageTransitionDelay; spring: 3; damping: 0.2}
    }

    // Show keyboard:
    function onShowKeyBoard()
    {
        keyboardPopup.state = "on"
    }

    Component.onCompleted: mainApplication.showKeyBoard.connect(onShowKeyBoard)
}

