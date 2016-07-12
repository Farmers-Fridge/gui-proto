import QtQuick 2.5
import Common 1.0

Column {
    property int buttonSize: 48
    property int buttonSpacing: 16
    property int value: 0
    property int minValue: 0
    property int maxValue: 10
    spacing: buttonSpacing
    width: buttonSize*2+buttonSpacing

    // Quantity:
    CommonText {
        text: qsTr("Quantity: ") + value
        anchors.horizontalCenter: row.horizontalCenter
    }

    Row {
        id: row
        spacing: buttonSpacing
        width: parent.width

        // Increment:
        ImageButton {
            width: buttonSize
            height: buttonSize
            source: "assets/ico-add.png"
            onClicked: {
                if (value < maxValue)
                    value++
            }
        }

        // Decrement:
        ImageButton {
            width: buttonSize
            height: buttonSize
            source: "assets/ico-substract.png"
            onClicked: {
                if (value > minValue)
                    value--
            }
        }
    }
}
