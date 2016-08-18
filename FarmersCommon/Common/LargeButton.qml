import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    property alias iconSource: icon.source
    property alias text: text.text
    scale: mouseArea.pressed ? .97 : 1
    signal buttonClicked()
    border.color: _colors.ffColor3
    border.width: 8
    radius: 8

    Image {
        id: icon
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height-16
    }

    StandardText {
        id: text
        anchors.centerIn: parent
        font.pixelSize: 48
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: buttonClicked()
    }
}

