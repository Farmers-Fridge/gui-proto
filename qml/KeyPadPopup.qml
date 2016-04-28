import QtQuick 2.5
import QtQuick.Window 2.0
import "keyboard"

Popup {
    id: keyPadPopup
    popupId: "_keypadpopup_"
    y: Screen.desktopAvailableHeight+40

    // Reset:
    function reset()
    {
        numericKeyPad.enteredText = ""
    }

    contents: NumericKeyPad {
        id: numericKeyPad
        anchors.centerIn: parent

        // OK clicked:
        onOkClicked: mainApplication.keyPadEnterKeyClicked(enteredText)

        // Cancel clicked:
        onCancelClicked: mainApplication.keyPadCancelKeyClicked()
    }

    // Reset:
    onStateChanged: if (state === "on") reset()

    // Transition:
    transitions: Transition {
        SpringAnimation {target: keyPadPopup; property: "y"; duration: _timeSettings.widgetAnimationDelay; spring: 3; damping: 0.2}
    }

    // Show key pad:
    function onShowKeyPad()
    {
        keyPadPopup.state = "on"
    }

    // Hide key pad:
    function onHideKeyPad()
    {
        keyPadPopup.state = ""
    }

    Component.onCompleted: {
        mainApplication.showKeyPad.connect(onShowKeyPad)
        mainApplication.hideKeyPad.connect(onHideKeyPad)
    }
}

