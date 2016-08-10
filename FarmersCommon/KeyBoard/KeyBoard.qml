import QtQuick 2.5
import QtQuick.Controls 1.4

// Keyboard component:
Rectangle {
    id: keyBoard
    width: 10*kbdSettings.keyWidth
    height: 4*kbdSettings.keyHeight

    // All upper case?
    property bool allUpperCase: false

    // Show symbol?
    property bool showSymbol: false

    // Keyboard text:
    property string enteredText: ""

    // Back space clicked:
    signal backSpaceClicked()

    // Enter clicked signal:
    signal enterClicked()

    // Return clicked:
    signal returnClicked()

    // .com clicked:
    signal dotComClicked(string text)

    // Space clicked:
    signal spaceClicked()

    // Clear clicked:
    signal clearClicked()

    // Key clicked:
    signal keyClicked(string key)

    // Bgk color:
    color: kbdSettings.bkgColor

    // Settings:
    KeyboardSettings {
        id: kbdSettings
    }

    // Keyboard row model:
    JSONListModel {
        id: keyboardRowModel
        source: kbdSettings.keyboardsDir + kbdSettings.source
        query: kbdSettings.rowQuery
    }

    // Proxy main text:
    Text {
        id: proxyMainTextItem
        color: kbdSettings.keyLabelColor
        font.pointSize: kbdSettings.keyLabelPointSize
        font.weight: kbdSettings.keyLabelFontWeight
        font.family: "Roboto"
        font.capitalization: keyBoard.allUpperCase ? Font.AllUppercase : Font.MixedCase
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // Erase text:
    function eraseText()
    {
        input.text = ""
    }

    // Main layout:
    Item {
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: "qrc:/assets/ico-farmers_bkg.png"
            Rectangle {
                color: _settings.ffGreen
                anchors.fill: parent
                opacity: .33
            }
        }
        Column {
            anchors.fill: parent
            Repeater {
                model: keyboardRowModel.model

                Row {
                    // Json list model:
                    JSONListModel {
                        id: keyboardKeyModel
                        source: kbdSettings.keyboardsDir + kbdSettings.source
                        query: "$.Keyboard.Row["+index+"].Key[*]"
                    }

                    // Key repeater:
                    Repeater {
                        id: keyRepeater
                        model: keyboardKeyModel.model

                        Key {
                            id: key
                            width: kbdSettings.keyWidth * model.ratio
                            height: kbdSettings.keyHeight
                            iconSource: model.icon !== "" ? kbdSettings.assetsDir + model.icon : ""
                            mainLabel: showSymbol ? model.symbol : model.label
                            mainFont: proxyMainTextItem.font
                            mainFontColor: proxyMainTextItem.color
                            keyColor: _settings.ffTransparent
                            keyBorderColor: _settings.ffWhite
                            keyPressedColor: kbdSettings.keyPressedColor
                            bounds: kbdSettings.bounds
                            radius: 8

                            onClicked: {
                                if (model.command !== "")
                                {
                                    switch(model.command)
                                    {
                                    case "shift":
                                        keyBoard.allUpperCase = !keyBoard.allUpperCase
                                        break
                                    case "backspace":
                                        keyBoard.backSpaceClicked()
                                        break
                                    case "enter":
                                        keyBoard.enterClicked()
                                        enteredText = ""
                                        break
                                    case "return":
                                        keyBoard.returnClicked()
                                        enteredText = ""
                                        break
                                    case "symbol":
                                        keyBoard.showSymbol = !keyBoard.showSymbol
                                        break
                                    case ".com":
                                        keyBoard.dotComClicked(model.label)
                                        break
                                    case "space":
                                        keyBoard.spaceClicked()
                                        break
                                    case "clear":
                                        keyBoard.clearClicked()
                                        break
                                    default: break
                                    }
                                }
                                else
                                {
                                    // Retrieve text (lower or upper case):
                                    var actualText = allUpperCase ? mainLabel.toUpperCase() : mainLabel
                                    enteredText += actualText
                                    keyBoard.keyClicked(actualText)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
