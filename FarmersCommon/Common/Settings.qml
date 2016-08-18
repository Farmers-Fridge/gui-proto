import QtQuick 2.5

Item {
    // Others:
    readonly property real footerRatio: .12
    readonly property real headerRatio: (footerRatio/2)*3
	readonly property int pageIdleTimeOut: 50000
    readonly property int idlePageTimeOut: 3000
    readonly property int cartViewRowHeight: 234
    readonly property int toggleButtonWidth: 16
    readonly property int toggleButtonHeight: 16
    readonly property int zMax: 1e9

    // Keyboard:
    readonly property string keyPressedColor: _colors.ffColor12
    readonly property string keyReleasedColor: _colors.ffColor14
    readonly property string keyboardBkgColor: _colors.ffColor4
}

