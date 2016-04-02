import QtQuick 2.5
import QtQuick.Window 2.0
import "keyboard"

Popup {
    id: numericKeyPadPopup
    popupId: "_numerickeypad_"
    y: Screen.desktopAvailableHeight+40

    // Reset:
    function reset()
    {
        numericKeyPad.enteredText = ""
    }

    contents: Item {
        width: parent.width
        height: parent.height

        NumericKeyPad {
            id: numericKeyPad
            anchors.centerIn: parent
            onOkClicked: {
                numericKeyPadPopup.state = ""
                if (enteredText === _appData.exitCode)
                    _exitCommand.execute()
            }
            onCancelClicked: numericKeyPadPopup.state = ""
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

    // Reset:
    onStateChanged: if (state === "on") reset()

    // Transition:
    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: _settings.pageTransitionDelay; spring: 3; damping: 0.2}
    }

    // Show key pad:
    function onShowKeyPad()
    {
        numericKeyPadPopup.state = "on"
    }

    Component.onCompleted: mainApplication.showKeyPad.connect(onShowKeyPad)
}

