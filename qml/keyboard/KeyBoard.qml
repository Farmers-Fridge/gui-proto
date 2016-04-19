import QtQuick 2.5
import QtQuick.Controls 1.4

// Keyboard component:
Rectangle {
    id: keyBoard
    width: 10*kbdSettings.keyWidth
    height: 4*kbdSettings.keyHeight + kbdSettings.textAreaHeight
    anchors.centerIn: parent

    // All upper case?
    property bool allUpperCase: false

    // Show symbol?
    property bool showSymbol: false

    // Enter clicked signal:
    signal enterClicked(string text)

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
        font.family: kbdSettings.keyLabelFontFamily
        font.capitalization: keyBoard.allUpperCase ? Font.AllUppercase : Font.MixedCase
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    // Erase text:
    function eraseText()
    {
        input.text = ""
    }

    // Key clicked:
    function onKeyClicked(text) {
        var actualText = allUpperCase ? text.toUpperCase() : text
        input.insert(input.cursorPosition, actualText)
    }

    // Enter clicked:
    function onEnterClicked()
    {
        var currentText = input.text
        keyboard.enterClicked(currentText)
        eraseText()
    }

    // Backspace clicked:
    function onBackSpaceClicked()
    {
        input.remove(input.cursorPosition-1, input.cursorPosition)
    }

    // .dotcom clicked:
    function onDotComClicked(text)
    {
        input.insert(input.cursorPosition, text)
    }

    // Space clicked:
    function onSpaceClicked()
    {
        input.insert(input.cursorPosition, " ")
    }

    // Clear clicked:
    function onClearClicked()
    {
        input.text = ""
    }

    Component{
        id: cursorA
        Rectangle {
            id: cursorRect
            width: 3
            height: kbdSettings.inputTextHeight-9
            //anchors.verticalCenter: input.verticalCenter
            color: "#1c94ff"
            visible: input.cursorVisible

            PropertyAnimation on opacity  {
                easing.type: Easing.OutSine
                loops: Animation.Infinite
                from: 0
                to: 1.0
                duration: 750
            }
        }
    }

    // Input text:
    TextArea {
        id: input
        width: parent.width
        height: kbdSettings.textAreaHeight
        font.family: kbdSettings.inputTextFontFamily
        font.pixelSize: kbdSettings.inputTextPixelSize
        font.weight: kbdSettings.inputTextFontWeight
        //maximumLength: kbdSettings.inputTextMaxCharCount
        //color: kbdSettings.inputTextColor
        //cursorDelegate: cursorA
        focus: true
        clip: true
    }

    // Main layout:
    Column {
        width: parent.width
        anchors.top: input.bottom
        anchors.bottom: parent.bottom
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
                        keyColor: kbdSettings.keyColor
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
                                    return;
                                case "backspace":
                                    keyBoard.onBackSpaceClicked()
                                    return;
                                case "enter":
                                    keyBoard.onEnterClicked()
                                    return;
                                case "symbol":
                                    keyBoard.showSymbol = !keyBoard.showSymbol
                                    return;
                                case ".com":
                                    keyBoard.onDotComClicked(model.label)
                                    return;
                                case "space":
                                    keyBoard.onSpaceClicked()
                                    return;
                                case "clear":
                                    keyBoard.onClearClicked()
                                    return;
                                default: return;
                                }
                            }
                            else keyBoard.onKeyClicked(mainLabel)
                        }
                    }
                }
            }
        }
    }
}
