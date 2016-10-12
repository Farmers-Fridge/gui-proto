import QtQuick 2.5
import Common 1.0

// Button container:
Item {
    id: buttonContainer
    width: parent.width
    height: 48
    anchors.bottom: parent.bottom
    property alias leftButtonText: leftButton.label
    property alias rightButtonText: rightButton.label
    signal leftButtonClicked()
    signal rightButtonClicked()

    Item {
        id: leftPart
        width: parent.width/2
        height: parent.height
        anchors.left: parent.left

        // Restore defaults:
        TextButton {
            id: leftButton
            anchors.centerIn: parent
            bold: true
            pixelSize: 24
            textColor: _colors.ffColor3
            onClicked: leftButtonClicked()
        }
    }

    Item {
        id: rightPart
        width: parent.width/2
        height: parent.height
        anchors.left: leftPart.right

        // Save
        TextButton {
            id: rightButton
            anchors.centerIn: parent
            bold: true
            pixelSize: 24
            textColor: _colors.ffColor3
            onClicked: rightButtonClicked()
        }
    }
}
