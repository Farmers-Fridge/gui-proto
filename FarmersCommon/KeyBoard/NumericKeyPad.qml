import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Common"

Rectangle {
    id: keyPad
    color: kbdSettings.keyboardBkgColor
    width: 3*(kbdSettings.keyWidth+4)+4
    height: 4*(kbdSettings.keyHeight+4)+4
    opacity: 0
    visible: opacity > 0

    // Invoker:
    property variant invoker

    // Max digits:
    property bool oneDigitOnly: false

    // Return key enabled state (virtual):
    function keyEnabledState(keyId)
    {
        return true
    }

    // Settings:
    KeyboardSettings {
        id: kbdSettings
    }

    // Current key:
    property int currentKey: -1

    // Entered text:
    property string enteredText: ""

    // Show header?
    property bool showHeader: true

    // Signals:
    signal okClicked(string enteredText)
    signal cancelClicked()

    // Header:
    TextField {
        id: textField
        anchors.bottom: parent.top
        width: parent.width
        height: 80
        // 4 caracters max:
        maximumLength: 4
        text: enteredText
        visible: showHeader
        style: TextFieldStyle {
            font.pixelSize: 48
            font.bold: true
            textColor: _colors.ffColor14
            background: Rectangle {
                radius: 2
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#333"
                border.width: 1
            }
        }

        // Clear button:
        ImageButton {
            id: clearButton
            anchors.right: parent.right
            height: parent.height-8
            anchors.verticalCenter: parent.verticalCenter
            source: "./assets/ico-clear.png"
            onClicked: enteredText = ""
        }
    }

    ListModel {
        id: keyModel
		Component.onCompleted: {
			for (var i=0; i<keyModel.count; i++) {
				var current = keyModel.get(i)
				keyModel.set(i, {"keyText": current.keyText, "keyId": current.keyId, 
					"keyIcon": current.keyIcon, "keyPressedColor": kbdSettings.keyPressedColor, 
						"keyReleasedColor": kbdSettings.keyReleasedColor})
			}
		}
        ListElement {
            keyText: "0"
            keyId: 0
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "1"
            keyId: 1
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "2"
            keyId: 2
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "3"
            keyId: 3
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "4"
            keyId: 4
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "5"
            keyId: 5
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "6"
            keyId: 6
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "7"
            keyId: 7
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "8"
            keyId: 8
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: "9"
            keyId: 9
            keyIcon: ""
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: ""
            keyId: 10
            keyIcon: "assets/ico-ok.png"
            keyPressedColor: ""
            keyReleasedColor: ""
        }
        ListElement {
            keyText: ""
            keyId: 11
            keyIcon: "assets/ico-cross.png"
            keyPressedColor: ""
            keyReleasedColor: ""
        }
    }

    // Proxy main text:
    Text {
        id: proxyMainTextItem
        color: kbdSettings.keyLabelColor
        font.pointSize: kbdSettings.keyLabelPointSize
        font.weight: kbdSettings.keyLabelFontWeight
        font.family: "Roboto"
        font.capitalization: Font.MixedCase
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Grid {
        id: layoutGrid
        anchors.fill: parent
        anchors.margins: 4
        rowSpacing: 4
        columnSpacing: 4
        rows: 4
        columns: 3

        Repeater {
            model: keyModel
            delegate: Key {
                id: key
                width: kbdSettings.keyWidth
                height: kbdSettings.keyHeight
                iconSource: keyIcon
                mainLabel: keyText
                mainFont: proxyMainTextItem.font
                mainFontColor: proxyMainTextItem.color
                enabled: keyEnabledState(keyId)
                onClicked: {
                    if (keyId >= 10)
                    {
                        // OK:
                        if (keyId === 10)
                            invoker.onOKClicked(enteredText)
                        else
                            if (keyId === 11) {
                                keyPad.state = ""
                            }
                    }
                    else {
                        currentKey = keyId
                        if (oneDigitOnly)
                            enteredText = ""
                        enteredText += keyText
                    }
                }
                opacity: enabled ? 1 : .5
            }
        }
    }

    // On state:
    states: State {
        name: "on"
        PropertyChanges {
            target: _privateNumericKeyPad
            opacity: 1
        }
    }

    // Behavior on opacity:
    Behavior on opacity {
        NumberAnimation {duration: 500}
    }

    onStateChanged: keyPad.enteredText = ""
}
