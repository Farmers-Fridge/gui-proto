import QtQuick 2.5
import Common 1.0

Rectangle {
    id: header
    color: _colors.ffColor2
    signal tabClicked(string categoryName)

    // Part1:
    Rectangle {
        id: part1
        color: _colors.ffColor2
        anchors.top: parent.top
        anchors.bottom: part2.top
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8

        // Fork button:
        ImageButton {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            source: "qrc:/assets/ico-fork.png"
        }

        // Sign-in:
        TextButton {
            id: signin
            anchors.right: register.left
            anchors.rightMargin: 24
            anchors.top: parent.top
            anchors.topMargin: 8
            bold: true
            pixelSize: 24
            textColor: _colors.ffColor3
            label: qsTr("SIGN-IN")
            onClicked: _signInDialog.state = "on"
        }

        // Register:
        TextButton {
            id: register
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            bold: true
            pixelSize: 24
            textColor: _colors.ffColor3
            label: qsTr("REGISTER")
            onClicked: _registerDialog.state = "on"
        }
    }

    // Part2:
    TabDisplay {
        id: part2
        width: parent.width
        anchors.bottom: parent.bottom
        onTabClicked: header.tabClicked(categoryName)
        Item {
            width: parent.width
            height: _settings.tabHeight - _settings.tabClickableAreaHeight
            anchors.bottom: parent.bottom

            // Part3:
            FilterDisplay {
                width: parent.width
                height: 1
                anchors.centerIn: parent
            }
        }
    }
}
