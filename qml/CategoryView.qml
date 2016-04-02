import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "script/Utils.js" as Utils

// Category view:
Item {
    anchors.fill: parent

    Item {
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        // Title:
        StyledTitle {
            id: styledTitle
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            title: _settings.mainTitle
        }

        // Top area:
        Item {
            id: topArea
            width: parent.width
            anchors.top: styledTitle.bottom
            anchors.bottom: centralLine.top

            Row {
                anchors.fill: parent
                Repeater {
                    model: _categoryModel
                    Item {
                        width: topArea.width/_categoryModel.count
                        height: topArea.height
                        TextPushButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: categoryName.toUpperCase()
                            selected: _controller.currentCategory === categoryName
                            onButtonClicked: _controller.currentCategory = categoryName
                        }
                    }
                }
            }
        }

        // Central line:
        Line {
            id: centralLine
            anchors.top: parent.top
            anchors.topMargin: (2/3)*parent.height
            anchors.left: styledTitle.left
            anchors.right: styledTitle.right
        }

        // Bottom area:
        Item {
            id: bottomArea
            width: parent.width
            anchors.top: centralLine.bottom
            anchors.bottom: parent.bottom

            // Exclusive group:
            ExclusiveGroup {
                id: exclusive
            }

            RowLayout {
                id: rowLayout
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                Repeater {
                    model: 4
                    CheckBox {
                        id: checkBox
                        text: qsTr(" LOREM IPSUM")
                        anchors.verticalCenter: parent.verticalCenter
                        exclusiveGroup: exclusive
                        height: parent.height-32
                        style: CheckBoxStyle {
                            indicator: Rectangle {
                                implicitWidth: checkBox.height
                                implicitHeight: checkBox.height
                                border.color: control.activeFocus ? "darkblue" : "gray"
                                border.width: 1
                                Rectangle {
                                    visible: control.checked
                                    color: "#555"
                                    border.color: "#333"
                                    radius: 1
                                    anchors.margins: 4
                                    anchors.fill: parent
                                }
                            }
                            label: Label {
                                text: control.text
                                font.pixelSize: rowLayout.height-32
                                anchors.leftMargin: 24
                            }
                        }
                    }
                }
            }
        }
    }
}
