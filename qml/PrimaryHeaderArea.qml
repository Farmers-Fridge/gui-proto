import QtQuick 2.4
import "script/Utils.js" as Utils

// Header:
Rectangle {
    id: header
    color: "transparent"
    border.color: _settings.appGreen
    border.width: 1

    CommonText {
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 48
        font.bold: true
        text: qsTr("*** CALL TO ACTION LOREM IPSUM *** ")
    }
}

