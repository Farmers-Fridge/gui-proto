import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

RowLayout {
    id: fontSizeControl
    implicitWidth: fontActionMinus.width + fontActionPlus.width + 2*spacing
    spacing: 4
    property alias minusAction: fontActionMinus.action
    property alias plusAction: fontActionPlus.action
    property alias value: label.text
    signal decreaseFont()
    signal increaseFont()

    // Decrement font size:
    ToolButton {
        id: fontActionMinus
        onClicked: decreaseFont()
    }

    // Label:
    Label {
        id: label
        width: 64
        height: parent.height
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    // Increment font size:
    ToolButton {
        id: fontActionPlus
        onClicked: increaseFont()
    }
}

