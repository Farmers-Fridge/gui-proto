import QtQuick 2.5

Item {
    id: kbdSettings

    // Keyboards dir:
    readonly property string keyboardsDir: "keyboards/"

    // Assets dir:
    readonly property string assetsDir: "assets/"

    // Source:
    readonly property string source: "keyboard_us.json"

    // Key size:
    readonly property int keyWidth: 105
    readonly property int keyHeight: 105

    // Bounds:
    readonly property int bounds: 3

    // Key color:
    readonly property color keyColor: _colors.ffColor14
    readonly property string keyPressedColor: _colors.ffColor12
    readonly property string keyReleasedColor: _colors.ffColor14

    // Keyboard bkg color:
    readonly property string keyboardBkgColor: _colors.ffColor4

    // Key label color:
    readonly property color keyLabelColor: _colors.ffColor6

    // Key label point size:
    readonly property int keyLabelPointSize: 28

    // Key label font weight:
    readonly property int keyLabelFontWeight: Font.Light

    // Row query:
    readonly property string rowQuery: "$.Keyboard.Row[*]"
}

