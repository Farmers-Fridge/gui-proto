import QtQuick 2.5

Item {
    readonly property color ffBlack: "black"
    readonly property color ffIvoryLight: "#F6F8F3"
    readonly property color ffGreen: "#9FC088"
    readonly property color ffLightGray: "lightgray"
    readonly property color ffOrange: "orange"
    readonly property color ffTransparent: "transparent"
    readonly property color ffBrown: "brown"
    readonly property color ffRed: "red"
    readonly property real footerRatio: .12
    readonly property real headerRatio: (footerRatio/2)*3
    readonly property int idlePageTimeOut: 3000
    readonly property int zMax: 1e9
}
