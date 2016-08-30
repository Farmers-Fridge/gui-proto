import QtQuick 2.5
import Common 1.0

Item {
    id: container
    property alias label: label.text
    property alias labelColor: label.color
    property bool selected: false
    width: _settings.toggleButtonWidth+8+label.implicitWidth
    signal clicked()

    // Checked box:
    Rectangle {
        id: checkBox
        width: _settings.toggleButtonWidth
        height: _settings.toggleButtonHeight
        color: _colors.ffColor11

        MouseArea {
            anchors.fill: parent
            onClicked: container.clicked()
        }
    }

    // Label:
    StandardText {
        id: label
        color: _colors.ffColor16
        anchors.right: parent.right
        anchors.verticalCenter: checkBox.verticalCenter

        MouseArea {
            anchors.fill: _colors.ff
            onClicked: container.clicked()
        }
    }

    // States:
    states: State {
        name: "checked"
        when: selected
        PropertyChanges {
            target: checkBox
            color: _colors.ffColor10
        }
    }
}
