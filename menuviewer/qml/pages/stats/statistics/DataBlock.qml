import QtQuick 2.5
import Common 1.0

// Data block:
Rectangle {
    property alias blockTitle: blockTitle.text
    property alias blockValue: blockValue.text

    Item {
        width: parent.width
        height: parent.height*.9
        anchors.centerIn: parent
        CommonText {
            id: blockTitle
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignTop
            font.pixelSize: 18
        }
        CommonText {
            id: blockValue
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignBottom
            font.pixelSize: 18
        }
    }
}
