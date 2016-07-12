import QtQuick 2.5

Item {
    id: reservedArea
    signal reservedAreaClicked()
    z: 1e9
    MouseArea {
        anchors.fill: parent
        onClicked: reservedAreaClicked()
    }
}
