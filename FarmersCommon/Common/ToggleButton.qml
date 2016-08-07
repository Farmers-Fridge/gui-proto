import QtQuick 2.5
import Common 1.0

Item {
    id: container
    property alias label: label.text
    property bool selected: false
    width: _settings.toggleButtonWidth+8+label.implicitWidth
    signal clicked()

    // Checked box:
    Rectangle {
        id: checkBox
        width: _settings.toggleButtonWidth
        height: _settings.toggleButtonHeight
        color: _settings.ffToggleButtonUncheckedColor
        MouseArea {
            anchors.fill: parent
            onClicked: container.clicked()
        }
    }

    // Label:
    StandardText {
        id: label
        color: _settings.ffWhite
        anchors.right: parent.right
        anchors.verticalCenter: checkBox.verticalCenter
    }

    // States:
    states: State {
        name: "checked"
        when: selected
        PropertyChanges {
            target: checkBox
            color: _settings.ffToggleButtonCheckedColor
        }
    }

}
