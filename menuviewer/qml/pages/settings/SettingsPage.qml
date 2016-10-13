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
                        anchors.bottom: colorSettingsControls.top
                        clip: true
                        model: _colorModel
                        spacing: 8
                    }

                    // Color settings controls:
                    SettingsControl {
                        id: colorSettingsControls
                        anchors.bottom: parent.bottom
                        width: parent.width
                        buttonText: "RESTORE DEFAULTS"
                        onButtonClicked: _controller.restoreDefaultSettingsForColors()
                    }
                }
            }

            Tab {
                title: qsTr("Layouts")
                Item {
                    anchors.fill: parent

                    // Layout view:
                    LayoutView {
                        id: layoutView
                        width: parent.width*2/3
                        height: width
                        anchors.centerIn: parent
                        model: _layoutMgr.nLayouts
                    }

                    // Color settings controls:
                    SettingsControl {
                        id: layoutSettingsControls
                        anchors.bottom: parent.bottom
                        width: parent.width
                        buttonText: "RESTORE DEFAULTS"
                        onButtonClicked: {
                            _controller.restoreDefaultSettingsForLayouts()
                        }
                    }
                }
            }
        }
    }
}

