import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Styles 1.4
import Components 1.0
import Common 1.0
import ".."

Rectangle {
    id: notePad
    radius: 3
    color: keyBoard.color
    width: keyBoard.width
    height: keyBoard.height+110
    property int toolBarItemSpacing: 4
    property int toolBarHeight: 48
    property string spaceStr: " "
    property bool simple: false
    property alias notepadLabel: notepadLabel.text

    // Set default state:
    opacity: 0
    visible: opacity > 0

    // Invoker:
    property variant invoker

    // Clear:
    function clear()
    {
        textArea.text = ""
    }

    // Error dialog:
    MessageDialog {
        id: errorDialog
    }

    // Bold:
    Action {
        id: boldAction
        iconSource: "assets/ico-textbold.png"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }

    // Italic:
    Action {
        id: italicAction
        iconSource: "assets/ico-textitalic.png"
        onTriggered: document.italic = !document.italic
        checkable: true
        checked: document.italic
    }

    // Underline:
    Action {
        id: underlineAction
        iconSource: "assets/ico-textunder.png"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }

    // Undo:
    Action {
        id: undoAction
        iconSource: "assets/ico-editundo.png"
        onTriggered: {
            textArea.undo()
            document.reset()
        }
    }

    // Redo:
    Action {
        id: redoAction
        iconSource: "assets/ico-editredo.png"
        onTriggered: {
            textArea.redo()
            document.reset()
        }
    }

    // Save as dialog:
    FileDialog {
        id: fileDialog
        nameFilters: ["Text files (*.txt)", "HTML files (*.html)"]
        onAccepted: {
            if (fileDialog.selectExisting)
                document.fileUrl = fileUrl
            else
                document.saveAs(fileUrl, selectedNameFilter)
        }
    }

    // Color dialog:
    ColorDialog {
        id: colorDialog
        color: "black"
        onAccepted: document.textColor = color
    }

    // File savas action:
    Action {
        id: fileSaveAsAction
        iconSource: "assets/ico-filesave.png"
        onTriggered: {
            fileDialog.selectExisting = false
            fileDialog.open()
        }
    }

    // Font size action (+):
    Action {
        id: fontActionPlus
        iconSource: "assets/ico-plus.png"
    }

    // Font size action (-):
    Action {
        id: fontActionMinus
        iconSource: "assets/ico-minus.png"
    }

    // Quit:
    Action {
        id: exitAction
        iconSource: "assets/ico-leaf.png"
        onTriggered: {
            notePad.state = ""
            notePad.clear()
        }
    }

    // Main toolbar:
    ToolBar {
        id: mainToolBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        height: toolBarHeight
        RowLayout {
            anchors.fill: parent
            StandardText {
                id: notepadLabel
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
            }

            /*
            spacing: toolBarItemSpacing
            ToolButton { action: fileSaveAsAction }
            ToolBarSeparator {}
            ToolButton { action: boldAction }
            ToolButton { action: italicAction }
            ToolButton { action: underlineAction }
            ToolBarSeparator {}
            ToolButton {
                id: colorButton
                property color color: document.textColor
                Rectangle {
                    id: colorRect
                    anchors.fill: parent
                    anchors.margins: 8
                    color: Qt.darker(document.textColor, colorButton.pressed ? 1.4 : 1)
                    border.width: 1
                    border.color: Qt.darker(colorRect.color, 2)
                }
                onClicked: {
                    colorDialog.color = document.textColor
                    colorDialog.open()
                }
            }
            ToolBarSeparator {}
            ToolButton { action: undoAction }
            ToolButton { action: redoAction }
            ToolBarSeparator {}
            FontSizeControl {
                id: fontSizeControl
                enabled: document.text !== ""
                minusAction: fontActionMinus
                plusAction: fontActionPlus
                value: document.fontSize
                onDecreaseFont: {
                    if (document.fontSize > 8)
                        document.fontSize--
                }
                onIncreaseFont: {
                    if (document.fontSize < 42)
                        document.fontSize++
                }
            }
            */
            Item { Layout.fillWidth: true }
            ToolButton { action: exitAction }
        }
    }

    // Text area:
    TextField {
        id: textArea
        style: TextFieldStyle {
            textColor: _colors.ffColor5
            background: Rectangle {
                color: _colors.ffColor18
                width: textArea.width
                height: textArea.height
                radius: 8
            }
        }
        Accessible.name: "document"
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainToolBar.bottom
        anchors.bottom: keyBoard.top
        anchors.margins: 4
        onTextChanged: document.text = text
        Component.onCompleted: {
            textArea.font.pointSize = document.fontSize
            forceActiveFocus()
        }
    }

    // Alpha numeric keypad:
    KeyBoard {
        id: keyBoard
        anchors.bottom: parent.bottom

        // Key clicked:
        onKeyClicked: textArea.insert(textArea.cursorPosition, key)

        // Enter clicked:
        onEnterClicked: invoker.onOKClicked(textArea.text)

        // Return clicked:
        onReturnClicked: textArea.insert(textArea.cursorPosition, "\n")

        // Backspace clicked:
        onBackSpaceClicked: textArea.remove(textArea.cursorPosition, textArea.cursorPosition-1)

        // .com clicked:
        onDotComClicked: textArea.insert(textArea.cursorPosition, text)

        // Space clicked:
        onSpaceClicked: textArea.insert(textArea.cursorPosition, spaceStr)

        // Clear clicked:
        onClearClicked: textArea.text = ""
    }

    // Main document handler:
    DocumentHandler {
        id: document
        target: textArea
        cursorPosition: textArea.cursorPosition
        selectionStart: textArea.selectionStart
        selectionEnd: textArea.selectionEnd
        onError: {
            errorDialog.text = message
            errorDialog.visible = true
        }
    }

    // On state:
    states: State {
        name: "on"
        PropertyChanges {
            target: notepad
            opacity: 1
        }
    }

    // Behavior on opacity:
    Behavior on opacity {
        NumberAnimation {duration: 500}
    }

    onStateChanged: {
        keyBoard.enteredText = ""
        textArea.text = ""
    }
}

