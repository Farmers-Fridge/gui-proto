import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import Common 1.0

Item {
    id: foot
    anchors.fill: parent

    Repeater {
        model: xmlVersionModel
        anchors.fill: parent
        delegate: Item {
            id: container
            anchors.fill: parent
            StandardText {
                anchors.centerIn: container
                font.pixelSize: 28
                text: versionModel + " " + statusModel
                wrapMode: Text.WordWrap
                color: "white"
            }
        }
    }
}

