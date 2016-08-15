import QtQuick 2.5
import Common 1.0

Column {
    id: clock
    width: 512
    height: 32

    property var locale: Qt.locale()
    property string dateTimeString: "Tue 2013-09-17 10:56:06"
    property int fontPixelSize: 18
    property color textColor: "white"

    // Timer:
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var current = new Date()
            dateText.text = Qt.formatDateTime(current, "dddd yyyy/MM/dd")
            timeText.text = Qt.formatDateTime(current, "hh:mm:ss")
        }
    }

    // Date text:
    StandardText {
        id: dateText
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: fontPixelSize
        color: textColor
    }

    // Time text:
    StandardText {
        id: timeText
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: fontPixelSize
        color: textColor
    }
}
