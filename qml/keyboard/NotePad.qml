import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.1
import Components 1.0
import ".."

Rectangle {
    id: notePad
    color: _colors.ffGray
    width: keyBoard.width
    height: 2*keyBoard.height
    property int toolBarItemSpacing: 4
    property int toolBarHeight: 48
    property string spaceStr: " "
    property bool simple: false

    // Enter clicked:
    signal enterClicked(string text)

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
        iconSource: "qrc:/qml/keyboard/assets/ico-textbold.png"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }

    // Italic:
    Action {
        id: italicAction
        iconSource: "qrc:/qml/keyboard/assets/ico-textitalic.png"
        onTriggered: document.italic = !document.italic
        checkable: true
        checked: document.italic
    }

    // Underline:
    Action {
        id: underlineAction
        iconSource: "qrc:/qml/keyboard/assets/ico-textunder.png"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }

    // Undo:
    Action {
        id: undoAction
        iconSource: "qrc:/qml/keyboard/assets/ico-editundo.png"
        onTriggered: {
            textArea.undo()
            document.reset()
        }
    }

    // Redo:
    Action {
        id: redoAction
        iconSource: "qrc:/qml/keyboard/assets/ico-editredo.png"
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
        iconSource: "qrc:/qml/keyboard/assets/ico-filesave.png"
        onTriggered: {
            fileDialog.selectExisting = false
            fileDialog.open()
        }
    }

    // Font size action (+):
    Action {
        id: fontActionPlus
        iconSource: "qrc:/qml/keyboard/assets/ico-plus.png"
    }

    // Font size action (-):
    Action {
        id: fontActionMinus
        iconSource: "qrc:/qml/keyboard/assets/ico-minus.png"
    }

    // Quit:
    Action {
        id: exitAction
        iconSource: "qrc:/qml/keyboard/assets/ico-cross.png"
        onTriggered: {
            mainApplication.hideNotePad()
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
            spacing: toolBarItemSpacing
            ToolButton { action: fileSaveAsAction }
            ToolBarSeparator {}
            ToolButton { action: boldAction }
            ToolButton { action: italicAction }
            ToolButton { action: underlineAction }
            ToolBarSeparator {}
            ToolButton {
                id: colorButton
                property variant color: document.textColor
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
            Item { Layout.fillWidth: true }
            ToolButton { action: exitAction }
        }
    }

    // Text area:
    TextArea {
        id: textArea
        Accessible.name: "document"
        frameVisible: false
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainToolBar.bottom
        anchors.bottom: keyBoard.top
        anchors.margins: 4
        baseUrl: "qrc:/"
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
        onEnterClicked: notePad.enterClicked(textArea.text)

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
}

