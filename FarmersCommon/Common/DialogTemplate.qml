import QtQuick 2.5
import QtQuick.Controls 1.4

Rectangle {
    id: dialogTemplate
    color: _colors.ffColor16
    border.color: _settings.keyboardBkgColor
    border.width: 3
    width: 512
    property alias contents: userArea.children

    // Set default state:
    opacity: 0
    visible: opacity > 0

    // User area:
    Item {
        id: userArea
        anchors.top: parent.top
        anchors.bottom: controlArea.top
        width: parent.width
    }

    // Control area:
    Item {
        id: controlArea
        anchors.bottom: parent.bottom
        width: parent.width
        height: 48

        // Cancel button:
        Button {
            id: cancelButton
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            text: qsTr("Cancel")
            onClicked: dialogTemplate.state = ""
        }

        // OK button:
        Button {
            id: okButton
            anchors.right: cancelButton.left
            anchors.rightMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            text: qsTr("OK")
            onClicked: dialogTemplate.state = ""
        }
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: dialogTemplate
            opacity: 1
        }
    }

    Behavior on opacity {
        NumberAnimation {duration: 500}
    }
}
