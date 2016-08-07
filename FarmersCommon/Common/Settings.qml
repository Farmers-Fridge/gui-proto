import QtQuick 2.5

Item {
    // Global colors:
    readonly property color ffBlack: "black"
    readonly property color ffIvoryLight: "#F6F8F3"
    readonly property color ffGreen: "#BCD4B9"
    readonly property color ffLightGray: "lightgray"
    readonly property color ffGray: "#606365"
    readonly property color ffDarkGray: "#57585C"
    readonly property color ffOtherGray: "#BABCB9"
    readonly property color ffToggleButtonCheckedColor: "#92B772"
    readonly property color ffToggleButtonUncheckedColor: "#DADFDB"
    readonly property color ffOrange: "orange"
    readonly property color ffTransparent: "transparent"
    readonly property color ffBrown: "brown"
    readonly property color ffRed: "red"
    readonly property color ffWhite: "white"

    // Used for colorizing rows in cart view:
    readonly property color ffRowColor1: "#C8DBC7"
    readonly property color ffRowColor2: "#E1D9C6"
    readonly property color ffRowColor3: "#BABBAB"

    // Others:
    readonly property real footerRatio: .12
    readonly property real headerRatio: (footerRatio/2)*3
	readonly property int pageIdleTimeOut: 50000
    readonly property int idlePageTimeOut: 3000
    readonly property int cartViewRowHeight: 234
    readonly property int toggleButtonWidth: 16
    readonly property int toggleButtonHeight: 16
    readonly property int zMax: 1e9
}

