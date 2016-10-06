import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Common 1.0
import "../.."

PageTemplate {
    id: checkOutPage

    // Hide header:
    headerVisible: false

    // Current color index:
    property int currentColorIndex: 0

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // Color dialog:
    ColorDialog {
        id: colorDialog
        title: qsTr("Please pick a color")
        modality: Qt.ApplicationModal
        onAccepted: {
            console.log("SELECTED COLOR = ", colorDialog.color)
            _colorModel.setColorValue(currentColorIndex, colorDialog.color)
        }
    }

    // Contents:
    contents: Item {
        anchors.fill: parent
        anchors.margins: 16

        // Tab view:
        TabView {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: buttonContainer.top
            anchors.bottomMargin: 8

            // Download state:
            Tab {
                title: qsTr("Local data status")

                ListView {
                    id: messageView
                    anchors.fill: parent
                    clip: true
                    model: _messageModel
                    spacing: 8
                    delegate: Item {
                        width: parent.width
                        height: 48

                        // Message display:
                        Item {
                            id: messageLabel
                            width: parent.width
                            height: parent.height

                            StandardText {
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                text: msgText
                                color: getMsgColor(index)

                                function getMsgColor(index)
                                {
                                    // OK:
                                    if (msgType === 0)
                                        return "green"
                                    // Warning:
                                    if (msgType === 1)
                                        return "blue"
                                    // Error:
                                    if (msgType === 2)
                                        return "red"
                                    // Info:
                                    if (msgType === 3)
                                        return "cyan"
                                    // Need update:
                                    if (msgType === 4)
                                        return "red"
                                    // Don't need update:
                                    if (msgType === 5)
                                        return "green"
                                    if (msgType === 6)
                                        return "brown"
                                    return "black"
                                }
                            }
                        }
                    }
                }
            }

            // Colors:
            Tab {
                title: qsTr("Colors")

                ListView {
                    id: colorView
                    anchors.fill: parent
                    clip: true
                    model: _colorModel
                    spacing: 8
                    delegate: Item {
                        width: parent.width
                        height: 48

                        // Color name:
                        Item {
                            id: colorNameLabel
                            width: 144
                            height: parent.height
                            StandardText {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: colorName
                            }
                        }

                        // Color value:
                        Rectangle {
                            id: colorValueRect
                            anchors.left: colorNameLabel.right
                            border.color: "black"
                            anchors.right: parent.right
                            height: 48
                            color: colorValue
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    currentColorIndex = index
                                    colorDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }

        // Button container:
        Item {
            id: buttonContainer
            width: parent.width
            height: 48
            anchors.bottom: parent.bottom

            Item {
                id: leftPart
                width: parent.width/2
                height: parent.height
                anchors.left: parent.left

                // Restore defaults:
                TextButton {
                    id: restoreDefaults
                    anchors.centerIn: parent
                    bold: true
                    pixelSize: 24
                    textColor: _colors.ffColor3
                    label: qsTr("RESTORE DEFAULTS")
                    onClicked: _controller.restoreDefaultSettings()
                }
            }

            Item {
                id: rightPart
                width: parent.width/2
                height: parent.height
                anchors.left: leftPart.right

                // Save
                TextButton {
                    id: save
                    anchors.centerIn: parent
                    bold: true
                    pixelSize: 24
                    textColor: _colors.ffColor3
                    label: qsTr("SAVE SETTINGS")
                    onClicked: _controller.saveSettings()
                }
            }
        }
    }
}

