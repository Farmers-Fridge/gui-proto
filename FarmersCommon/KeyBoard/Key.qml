import QtQuick 2.5

Item {
    id: root

    property alias mainLabel: mainLabelItem.text
    property alias iconSource: icon.source
    property int bounds: 2

    property alias mainFont: mainLabelItem.font
    property alias mainFontColor: mainLabelItem.color

    property color keyColor: _settings.keyReleasedColor
    property color keyPressedColor: _settings.keyPressedColor
    property color keyBorderColor: _colors.ffColor13

    property alias radius: backgroundItem.radius

    signal clicked()

    Rectangle {
        id: backgroundItem
        anchors.fill: parent
        anchors.margins: root.bounds
        color: mouseArea.pressed ? keyPressedColor : keyColor
        border.color: keyBorderColor
        Image {
            id: icon
            smooth: true
            anchors.fill: parent
            anchors.margins: 4
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: mainLabelItem
            smooth: true
            anchors.centerIn: parent
            width: parent.width
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
        hoverEnabled: true
        onEntered: backgroundItem.color = keyPressedColor
        onExited: backgroundItem.color = keyColor
    }
}
