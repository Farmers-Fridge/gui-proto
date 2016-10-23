import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

Rectangle {
    id: signInDialog
    color: _colors.ffColor16
    border.color: _settings.keyboardBkgColor
    border.width: 3
    width: 512
    height: 320

    // Set default state:
    opacity: 0
    visible: opacity > 0

    // Login area:
    Item {
        id: loginArea
        width: parent.width
        height: parent.height/2
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            StandardText {
                text: qsTr("Login:")
                color: _colors.ffColor20
            }
            TextField {
                placeholderText: qsTr("Enter Login")
                font.pixelSize: 28
                width: 256
            }
        }
    }

    // Password area:
    Item {
        width: parent.width
        height: parent.height/2
        anchors.top: loginArea.bottom
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            StandardText {
                text: qsTr("Password:")
                color: _colors.ffColor20
            }
            TextField {
                placeholderText: qsTr("Enter Password")
                font.pixelSize: 28
                width: 256
            }
        }
    }

    // Behavior on opacity:
    Behavior on opacity {
        NumberAnimation {duration: 500}
    }

    // On state:
    states: State {
        name: "on"
        PropertyChanges {
            target: signInDialog
            opacity: 1
        }
    }

    // Cancel button:
    Button {
        id: cancelButton
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        text: qsTr("Cancel")
        onClicked: signInDialog.state = ""
    }

    // OK button:
    Button {
        id: okButton
        anchors.right: cancelButton.left
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        text: qsTr("OK")
        onClicked: signInDialog.state = ""
    }
}
