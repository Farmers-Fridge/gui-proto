import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.1
import Components 1.0
import ".."

Rectangle {
    id: notepad
    color: _colors.ffLightGray
    opacity: 0
    visible: opacity !== 0
    width: alphaNumericKeyPad.width
    height: alphaNumericKeyPad.height*2
    property string spaceStr: " "

    // Show notepad:
    function onShowNotePad()
    {
        notepad.state = "on"
    }

    // Error dialog:
    MessageDialog {
        id: errorDialog
    }

    // Bold:
    Action {
        id: boldAction
        iconSource: "qrc:/qml/notepad/assets/ico-textbold.png"
        onTriggered: document.bold = !document.bold
        checkable: true
        checked: document.bold
    }

    // Italic:
    Action {
        id: italicAction
        iconSource: "qrc:/qml/notepad/assets/ico-textitalic.png"
        onTriggered: document.italic = !document.italic
        checkable: true
        checked: document.italic
    }

    // Underline:
    Action {
        id: underlineAction
        iconSource: "qrc:/qml/notepad/assets/ico-textunder.png"
        onTriggered: document.underline = !document.underline
        checkable: true
        checked: document.underline
    }

    // Undo:
    Action {
        id: undoAction
        iconSource: "qrc:/qml/notepad/assets/ico-editundo.png"
        onTriggered: {
            textArea.undo()
            document.reset()
        }
    }

    // Redo:
    Action {
        id: redoAction
        iconSource: "qrc:/qml/notepad/assets/ico-editredo.png"
        onTriggered: {
            textArea.redo()
            document.reset()
        }
    }

    // Exit:
    Action {
        id: exitAction
        iconSource: "qrc:/icons/ico-cross.png"
        onTriggered: notepad.state = ""
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
        iconSource: "qrc:/qml/notepad/assets/ico-filesave.png"
        onTriggered: {
            fileDialog.selectExisting = false
            fileDialog.open()
        }
    }

    // Font action:
    Action {
        id: fontAction
        iconSource: "qrc:/icons/ico-font.png"
        onTriggered: {
            fontView.state = (fontView.state == "on" ? "" : "on")
        }
    }

    // Main toolbar:
    ToolBar {
        id: mainToolBar
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        height: _settings.keyPadToolbarHeight
        RowLayout {
            anchors.fill: parent
            spacing: _settings.toolbarItemSpacing
            ToolButton { action: fileSaveAsAction }
            ToolBarSeparator {}
            ToolButton { action: boldAction }
            ToolButton { action: italicAction }
            ToolButton { action: underlineAction }
            ToolBarSeparator {}
            ToolButton {
                id: colorButton
                property var color: document.textColor
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
            Item { Layout.fillWidth: true }
            ToolButton { action: exitAction }
        }
    }

    // Secondary toolbar:
    ToolBar {
        id: secondaryToolBar
        anchors.top: mainToolBar.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        height: _settings.keyPadToolbarHeight

        RowLayout {
            anchors.fill: parent
            spacing: _settings.toolbarItemSpacing
            IncrementalButton {
                id: fontSizeControl
                property bool valueGuard: true
                value: 0
                onValueChanged: if (valueGuard) document.fontSize = value
            }
            Item { Layout.fillWidth: true }
            ToolButton { action: fontAction }
        }
    }

    // Text area:
    TextArea {
        id: textArea
        Accessible.name: "document"
        frameVisible: false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: secondaryToolBar.bottom
        anchors.topMargin: 4
        anchors.bottom: alphaNumericKeyPad.top
        anchors.margins: 4
        baseUrl: "qrc:/"
        text: document.text
        //textFormat: TextEdit.RichText
        Component.onCompleted: forceActiveFocus()
    }

    // Font view:
    FontView {
        id: fontView
        z: -1
        anchors.top: textArea.top
        anchors.bottom: textArea.bottom
        width: 288
        height: alphaNumericKeyPad.height
        onFontSelected: {
            if (special == false) {
                document.fontFamily = Qt.fontFamilies()[fontIndex]
            }
        }
    }

    // Alpha numeric keypad:
    AlphaNumericKeyPad {
        id: alphaNumericKeyPad
        anchors.bottom: parent.bottom

        // Key clicked:
        onKeyClicked: textArea.insert(textArea.cursorPosition, text)

        // Enter clicked:
        onEnterClicked: textArea.append("")

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
        Component.onCompleted: document.fileUrl = "qrc:/qml/notepad/example.html"
        onFontSizeChanged: {
            fontSizeControl.valueGuard = false
            fontSizeControl.value = document.fontSize
            fontSizeControl.valueGuard = true
        }
        onFontFamilyChanged: {
            var index = Qt.fontFamilies().indexOf(document.fontFamily)
            if (index == -1) {
                fontView.setCurrentIndex(0)
                fontView.special = true

            } else {
                fontView.setCurrentIndex(index)
                fontView.special = false
            }
        }
        onError: {
            errorDialog.text = message
            errorDialog.visible = true
        }
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: notepad
            opacity: 1
        }
    }

    // Erase on visibility changed:
    onStateChanged: {
        if (state == "on")
            textArea.text = ""
    }

    // Behavior on opacity:
    Behavior on opacity {
        PropertyAnimation {duration: _settings.keyboardAnimDuration}
    }
}
