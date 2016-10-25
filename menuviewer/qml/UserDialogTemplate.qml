import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

Rectangle {
    id: userDialogTemplate
    color: _colors.ffColor16
    border.color: _settings.keyboardBkgColor
    border.width: 3
    property alias model: userListView.model
    property int blockSize: 96
    width: 512
    implicitHeight: (model.count+1)*blockSize

    // Set default state:
    opacity: 0
    visible: opacity > 0

    // User area:
    Item {
        id: userArea
        anchors.top: parent.top
        anchors.bottom: controlArea.top
        width: parent.width
        ListView {
            id: userListView
            anchors.fill: parent
            anchors.margins: 8
            clip: true
            spacing: 8
            interactive: false
            delegate: StandardInput {
                width: parent.width
                height: 96
                title: inputTitle
                placeHolderText: inputPlaceHolder
            }
        }
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
            onClicked: userDialogTemplate.state = ""
        }

        // OK button:
        Button {
            id: okButton
            anchors.right: cancelButton.left
            anchors.rightMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            text: qsTr("OK")
            onClicked: userDialogTemplate.state = ""
        }
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: userDialogTemplate
            opacity: 1
        }
    }

    Behavior on opacity {
        NumberAnimation {duration: 500}
    }
}
