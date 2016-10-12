import QtQuick 2.5
import Common 1.0

// Button container:
Item {
    id: buttonContainer
    width: parent.width
    height: 48
    anchors.bottom: parent.bottom
    property alias buttonText: button.label
    signal buttonClicked()

    // Restore defaults:
    TextButton {
        id: button
        anchors.centerIn: parent
        bold: true
        pixelSize: 24
        textColor: _colors.ffColor3
        onClicked: buttonClicked()
    }
}
