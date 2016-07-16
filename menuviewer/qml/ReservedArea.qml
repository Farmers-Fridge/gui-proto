import QtQuick 2.5

Item {
    id: reservedArea
    signal reservedAreaClicked()
    z: _settings.zMax
    MouseArea {
        anchors.fill: parent
        onClicked: reservedAreaClicked()
    }
}
