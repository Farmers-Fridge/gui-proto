import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: keyPad
    color: _settings.keyboardBkgColor
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
        anchors.bottom: parent.top
        width: parent.width
        height: 80
        text: enteredText
        visible: showHeader
        style: TextFieldStyle {
            font.pixelSize: 48
            font.bold: true
            textColor: _settings.ffBrown
            background: Rectangle {
                radius: 2
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#333"
                border.width: 1
            }
        }
    }

    ListModel {
        id: keyModel
        ListElement {
            keyText: "0"
            keyId: 0
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "1"
            keyId: 1
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "2"
            keyId: 2
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "3"
            keyId: 3
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "4"
            keyId: 4
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "5"
            keyId: 5
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "6"
            keyId: 6
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "7"
            keyId: 7
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "8"
            keyId: 8
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: "9"
            keyId: 9
            keyIcon: ""
            keyPressedColor: "lightgreen"
            keyReleasedColor: "#9B5A3C"
        }
        ListElement {
            keyText: ""
            keyId: 10
            keyIcon: "assets/ico-ok.png"
            keyPressedColor: "steelblue"
            keyReleasedColor: "lightblue"
        }
        ListElement {
            keyText: ""
            keyId: 11
            keyIcon: "assets/ico-cross.png"
            keyPressedColor: "steelblue"
            keyReleasedColor: "lightblue"
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
                keyColor: "#9B5A3C"
                opacity: enabled ? 1 : .5
            }
        }
    }

    // On state:
    states: State {
        name: "on"
        PropertyChanges {
            target: privateNumericKeyPad
            opacity: 1
        }
    }

    // Behavior on opacity:
    Behavior on opacity {
        NumberAnimation {duration: 500}
    }

    onStateChanged: keyPad.enteredText = ""
}
