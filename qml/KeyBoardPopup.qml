import QtQuick 2.5
import "keyboard"
import QtQuick.Window 2.0

Popup {
    id: keyboardPopup
    popupId: "_keyboardpoup_"
    y: Screen.desktopAvailableHeight+40

    contents: KeyBoard {
        id: keyboard
        anchors.centerIn: parent
        onEnterClicked: {
            _keyboardText = text
            mainApplication.keyBoardEnterKeyClicked()
        }
    }

    // Transition:
    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: _settings.pageTransitionDelay; spring: 3; damping: 0.2}
    }

    // Show key board:
    function onShowKeyBoard()
    {
        keyboardPopup.state = "on"
    }

    // Hide key pad:
    function onHideKeyBoard()
    {
        keyboardPopup.state = ""
    }

    Component.onCompleted: {
        // Show keyboard:
        mainApplication.showKeyBoard.connect(onShowKeyBoard)
        mainApplication.hideKeyBoard.connect(onHideKeyBoard)

        // Show notepad:
        mainApplication.showNotePad.connect(onShowKeyBoard)
        mainApplication.hideNodePad.connect(onHideKeyBoard)
    }
}

