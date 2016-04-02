import QtQuick 2.5

Rectangle {
    id: keyPad
    color: kbdSettings.bkgColor
    width: 3*(kbdSettings.keyWidth+4)+4
    height: 4*(kbdSettings.keyHeight+4)+4

    // Settings:
    KeyboardSettings {
        id: kbdSettings
    }

    // Current key:
    property int currentKey: -1

    // Entered text:
    property string enteredText: ""

    // Signals:
    signal okClicked(string enteredText)
    signal cancelClicked()

    ListModel {
        id: keyModel
        ListElement {
            keyText: "0"
            keyId: 0
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "1"
            keyId: 1
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "2"
            keyId: 2
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "3"
            keyId: 3
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "4"
            keyId: 4
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "5"
            keyId: 5
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "6"
            keyId: 6
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "7"
            keyId: 7
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "8"
            keyId: 8
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: "9"
            keyId: 9
            keyIcon: ""
            keyPressedColor: "#1ABC9C"
            keyReleasedColor: "#34495E"
        }
        ListElement {
            keyText: ""
            keyId: 10
            keyIcon: "qrc:/qml/images/ico-ok.png"
            keyPressedColor: "steelblue"
            keyReleasedColor: "lightblue"
        }
        ListElement {
            keyText: ""
            keyId: 11
            keyIcon: "qrc:/qml/images/ico-cross.png"
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
        font.family: kbdSettings.keyLabelFontFamily
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
                keyColor: "#34495E"
                mainFontColor: proxyMainTextItem.color
                keyPressedColor: "#1ABC9C"
                onClicked: {
                    if (keyId >= 10)
                    {
                        // OK:
                        if (keyId === 10)
                            okClicked(enteredText)
                        else
                        if (keyId === 11)
                            cancelClicked()
                    }
                    else {
                        currentKey = keyId
                        enteredText += keyText
                    }
                }
                opacity: enabled ? 1 : .75
            }
        }
    }
}
