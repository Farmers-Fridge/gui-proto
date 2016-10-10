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
            anchors.fill: parent

            // Message view:
            Tab {
                title: qsTr("Local data status")

                // Message view:
                MessageView {
                    id: messageView
                    anchors.fill: parent
                    clip: true
                    model: _messageModel
                    spacing: 8
                }
            }

            // Colors:
            Tab {
                title: qsTr("Colors")

                Item {
                    anchors.fill: parent

                    // Color view:
                    ColorView {
                        id: colorView
                        width: parent.width
                        anchors.top: parent.top
                        anchors.bottom: buttonContainer.top
                        clip: true
                        model: _colorModel
                        spacing: 8
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

            Tab {
                title: qsTr("Layouts")
                Item {
                    anchors.fill: parent
                    LayoutView {
                        anchors.fill: parent
                        model: _layoutMgr.nLayouts
                    }
                }
            }
        }
    }
}

