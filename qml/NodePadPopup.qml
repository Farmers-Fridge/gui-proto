import QtQuick 2.5
import "keyboard"
import QtQuick.Window 2.0

Popup {
    id: notePadPopup
    popupId: "_notepadpopup_"
    y: Screen.desktopAvailableHeight+40

    // Notepad:
    contents: NotePad {
        id: notePad
        anchors.centerIn: parent

        onEnterClicked: {
            _notePadText = text
            mainApplication.notePadEnterClicked()
            notePad.clear()
        }
    }

    // Transition:
    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: _timeSettings.widgetAnimationDelay; spring: 3; damping: 0.2}
    }

    // Show notepad:
    function onShowNotePad()
    {
        notePadPopup.state = "on"
    }

    // Hide notepad:
    function onHideNotePad()
    {
        notePadPopup.state = ""
    }

    Component.onCompleted: {
        // Show notepad:
        mainApplication.showNodePad.connect(onShowNotePad)
        mainApplication.hideNotePad.connect(onHideNotePad)
    }
}

