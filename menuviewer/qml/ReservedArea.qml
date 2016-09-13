import QtQuick 2.5
import Common 1.0

Item {
    id: reservedArea
    signal reservedAreaClicked()
    z: _settings.zMax

    ImageButton {
        height: parent.height-32
        anchors.centerIn: parent
        source: "qrc:/assets/ico-locker.png"
        onClicked: reservedAreaClicked()
    }
}
