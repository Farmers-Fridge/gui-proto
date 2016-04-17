import QtQuick 2.5
import QtQuick.Window 2.0
import "keyboard"

Popup {
    id: stockKeyPadPopup
    popupId: "_stockkeypadpopup_"
    y: Screen.desktopAvailableHeight+40

    // Reset:
    function reset()
    {
        stockNumericKeyPad.enteredText = ""
    }

    contents: StockNumericKeyPad {
        id: stockNumericKeyPad
        anchors.centerIn: parent

        // OK clicked:
        onOkClicked: mainApplication.stockKeyPadEnterKeyClicked(enteredText)

        // Cancel clicked:
        onCancelClicked: mainApplication.stockKeyPadCancelKeyClicked()
    }

    // Reset:
    onStateChanged: if (state === "on") reset()

    // Transition:
    transitions: Transition {
        SpringAnimation {target: stockKeyPadPopup; property: "y"; duration: _settings.pageTransitionDelay; spring: 3; damping: 0.2}
    }

    // Show stock key pad:
    function onShowStockKeyPad(theoPar, actualPar)
    {
        stockNumericKeyPad.theoPar = theoPar
        stockNumericKeyPad.currentKey = actualPar
        stockKeyPadPopup.state = "on"
    }

    // Hide stock key pad:
    function onHideStockKeyPad()
    {
        stockKeyPadPopup.state = ""
    }

    Component.onCompleted: {
        mainApplication.showStockKeyPad.connect(onShowStockKeyPad)
        mainApplication.hideStockKeyPad.connect(onHideStockKeyPad)
    }
}

