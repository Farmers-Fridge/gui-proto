import QtQuick 2.5
import Common 1.0

Rectangle {
    property alias bottomAreaSource: bottomArea.source
    color: _settings.ffIvoryLight
    signal tabClicked()

    Column {
        anchors.fill: parent

        // Part1:
        Rectangle {
            id: part1
            color: _settings.ffIvoryLight
            width: parent.width
            height: parent.height/3
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
                border.color: _settings.ffGreen
                bold: true
                pixelSize: 24
                textColor: _settings.ffGreen
                label: qsTr("SIGN-IN")
            }

            // Register:
            TextButton {
                id: register
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
                border.color: _settings.ffGreen
                bold: true
                pixelSize: 24
                textColor: _settings.ffGreen
                label: qsTr("REGISTER")
            }
        }

        // Part2:
        Rectangle {
            id: part2
            color: _settings.ffIvoryLight
            width: parent.width
            height: parent.height/3

            Row {
                anchors.fill: parent
                Repeater {
                    model: _categoryModel
                    TabButton {
                        width: part2.width/_categoryModel.count
                        height: part2.height
                        color: _settings.ffIvoryLight
                        backgroundImage: categoryName === "Drinks" ?
                            "qrc:/assets/ico-drinks.png" :
                            "qrc:/assets/ico-primary-darkbar.png"
                        selected: _controller.currentCategory === categoryName
                        onClicked: {
                            _controller.currentCategory = categoryName
                            tabClicked()
                        }
                    }
                }
            }
        }

        // Part3:
        Rectangle {
            id: part3
            color: _settings.ffIvoryLight
            width: parent.width
            height: parent.height/3

            // Footer:
            Image {
                id: bottomArea
                anchors.fill: parent
                fillMode: Image.Stretch
            }
        }
    }
}
