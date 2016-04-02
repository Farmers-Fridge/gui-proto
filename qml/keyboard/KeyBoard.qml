import QtQuick 2.5

Item {
    id: keyboard

    // Settings:
    KeyboardSettings {
        id: kbdSettings
    }

    width: 10*kbdSettings.keyWidth+kbdSettings.margin
    height: 4.5*kbdSettings.keyHeight+kbdSettings.margin

    signal enterClicked(string text)

    Rectangle {
        width: 10*kbdSettings.keyWidth
        height: 4.5*kbdSettings.keyHeight
        anchors.centerIn: parent

        // Bgk color:
        color: kbdSettings.bkgColor

        // Keyboard row model:
        JSONListModel {
            id: keyboardRowModel
            source: kbdSettings.keyboardsDir + kbdSettings.source
            query: kbdSettings.rowQuery
            onModelReady: keyboardLoader.sourceComponent = keyboardComponent
        }

        // Keyboard component:
        Component {
            id: keyboardComponent
            Item {
                id: keyboardItem
                anchors.fill: parent

                // All upper case?
                property bool allUpperCase: false

                // Show symbol?
                property bool showSymbol: false

                // Proxy main text:
                Text {
                    id: proxyMainTextItem
                    color: kbdSettings.keyLabelColor
                    font.pointSize: kbdSettings.keyLabelPointSize
                    font.weight: kbdSettings.keyLabelFontWeight
                    font.family: kbdSettings.keyLabelFontFamily
                    font.capitalization: keyboardItem.allUpperCase ? Font.AllUppercase : Font.MixedCase
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                // State changed:
                function onKeyBoardStateChanged()
                {
                    if (keyboard.state === "on")
                        eraseText()
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
                        anchors.verticalCenter: input.verticalCenter
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
                TextInput {
                    id: input
                    width: parent.width
                    height: kbdSettings.inputTextHeight
                    font.family: kbdSettings.inputTextFontFamily
                    font.pixelSize: kbdSettings.inputTextPixelSize
                    font.weight: kbdSettings.inputTextFontWeight
                    maximumLength: kbdSettings.inputTextMaxCharCount
                    color: kbdSettings.inputTextColor
                    cursorDelegate: cursorA
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
                                onModelReady: keyRepeater.model = keyboardKeyModel.model
                            }

                            // Key repeater:
                            Repeater {
                                id: keyRepeater

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
                                                keyboardItem.allUpperCase = !keyboardItem.allUpperCase
                                                return;
                                            case "backspace":
                                                keyboardItem.onBackSpaceClicked()
                                                return;
                                            case "enter":
                                                keyboardItem.onEnterClicked()
                                                return;
                                            case "symbol":
                                                keyboardItem.showSymbol = !keyboardItem.showSymbol
                                                return;
                                            case ".com":
                                                keyboardItem.onDotComClicked(model.label)
                                                return;
                                            case "space":
                                                keyboardItem.onSpaceClicked()
                                                return;
                                            case "clear":
                                                keyboardItem.onClearClicked()
                                                return;
                                            default: return;
                                            }
                                        }
                                        else keyboardItem.onKeyClicked(mainLabel)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Keyboard loader:
        Item {
            anchors.fill: parent

            Loader {
                id: keyboardLoader
                anchors.fill: parent
                onLoaded: {
                    keyboard.stateChanged.connect(item.onKeyBoardStateChanged)
                }
            }
        }
    }
}
