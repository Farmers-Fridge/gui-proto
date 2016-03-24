import QtQuick 2.4
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
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            title: _settings.mainTitle
        }

        // Top area:
        Item {
            width: parent.width
            anchors.top: styledTitle.bottom
            anchors.bottom: centralLine.top

            Row {
                anchors.fill: parent
                Repeater {
                    model: _categoryModel
                    Item {
                        width: parent.width/_categoryModel.count
                        height: parent.height
                        TextPushButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: categoryName.toUpperCase()
                            selected: _controller.currentCategory === categoryName
                            onButtonClicked: {
                                _controller.currentCategory = categoryName
                                mainApplication.updateBrowserView(index)
                            }
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
            width: parent.width
            anchors.top: centralLine.bottom
            anchors.bottom: parent.bottom

            // Exclusive group:
            ExclusiveGroup {
                id: exclusive
            }

            RowLayout {
                width: parent.width/1.5
                height: parent.height
                anchors.centerIn: parent
                Repeater {
                    model: 4
                    CheckBox {
                        text: qsTr(" LOREM IPSUM")
                        anchors.verticalCenter: parent.verticalCenter
                        exclusiveGroup: exclusive
                        style: CheckBoxStyle {
                            indicator: Rectangle {
                                implicitWidth: 48
                                implicitHeight: 48
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
                                font.pixelSize: 18
                                anchors.leftMargin: 24
                            }
                        }
                    }
                }
            }
        }
    }
}
