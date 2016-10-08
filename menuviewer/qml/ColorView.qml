import QtQuick 2.5
import Common 1.0

ListView {
    id: colorView
    clip: true
    spacing: 8
    delegate: Item {
        width: parent.width
        height: 48

        // Color name:
        Item {
            id: colorNameLabel
            width: 144
            height: parent.height
            StandardText {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: colorName
            }
        }

        // Color value:
        Rectangle {
            id: colorValueRect
            anchors.left: colorNameLabel.right
            border.color: "black"
            anchors.right: parent.right
            height: 48
            color: colorValue
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentColorIndex = index
                    colorDialog.open()
                }
            }
        }
    }
}
