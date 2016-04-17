import QtQuick 2.5

Rectangle {
    id: root
    property alias label: text.text
    property string labelOn: "ON"
    property string labelOff: "OFF"
    property bool active: false
    signal toggled
    width: 149
    height: 30
    radius: 3
    color: active ? _colors.ffPink : _colors.ffYellow
    border.width: 1
    Text { id: text; anchors.centerIn: parent; font.pixelSize: 14; text: (active ? labelOn : labelOff) }
    MouseArea {
        anchors.fill: parent
        onClicked: { active = !active; root.toggled() }
    }
}
