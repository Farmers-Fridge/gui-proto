import QtQuick 2.5

Item {
    id: kbdSettings

    // Keyboards dir:
    readonly property string keyboardsDir: "qrc:/qml/keyboard/keyboards/"

    // Assets dir:
    readonly property string assetsDir: "qrc:/qml/keyboard/assets/"

    // Bkg color:
    readonly property string bkgColor: _colors.ffKbdBkgColor

    // Source:
    readonly property string source: "keyboard_us.json"

    // Key size:
    readonly property int keyWidth: 105
    readonly property int keyHeight: 105

    // Bounds:
    readonly property int bounds: 3

    // Key color:
    readonly property color keyColor: _colors.ffKeyColor
    readonly property color keyPressedColor: _colors.ffKeyPressedColor

    // Key label color:
    readonly property color keyLabelColor: _colors.ffKeyLabelColor

    // Key label point size:
    readonly property int keyLabelPointSize: 28

    // Key label font weight:
    readonly property int keyLabelFontWeight: Font.Light

    // Row query:
    readonly property string rowQuery: "$.Keyboard.Row[*]"
}

