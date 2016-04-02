import QtQuick 2.5

Item {
    id: kbdSettings

    // Keyboards dir:
    readonly property string keyboardsDir: "qrc:/qml/keyboard/keyboards/"

    // Assets dir:
    readonly property string assetsDir: "qrc:/qml/keyboard/assets/"

    // Bkg color:
    readonly property string bkgColor: "#192430"

    // Source:
    readonly property string source: "keyboard_us.json"

    // Key size:
    readonly property int keyWidth: 100
    readonly property int keyHeight: 110

    // Bounds:
    readonly property int bounds: 3

    // Key color:
    readonly property color keyColor: "#34495E"
    readonly property color keyPressedColor: "#1ABC9C"

    // Key label color:
    readonly property color keyLabelColor: "#F2F2F2"

    // Key label point size:
    readonly property int keyLabelPointSize: 32

    // Key label font weight:
    readonly property int keyLabelFontWeight: Font.Light

    // Key label font family:
    readonly property string keyLabelFontFamily: "Roboto"

    // Input text maximum character count:
    readonly property int inputTextMaxCharCount: 50

    // Input text color:
    readonly property color inputTextColor: "white"

    // Input text height:
    readonly property int inputTextHeight: keyHeight/2

    // Input text pixel size:
    readonly property int inputTextPixelSize: keyHeight/2

    // Input text font family:
    readonly property string inputTextFontFamily: "Roboto"

    // Input text font weight:
    readonly property int inputTextFontWeight: Font.Bold

    // Row query:
    readonly property string rowQuery: "$.Keyboard.Row[*]"

    // Margin:
    readonly property int margin: 9
}

