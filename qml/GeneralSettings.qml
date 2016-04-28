import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    // Main title:
    property string mainTitle: qsTr("CHOOSE CATEGORY & SELECT ITEMS")

    // Enter reference screen size:
    readonly property int refScreenWidth: 1080
    readonly property int refScreenHeight: 1920

    // Menu view top area height:
    readonly property int toolbarHeight: (233/refScreenHeight)*Screen.desktopAvailableHeight

    // Checkout popup header height:
    readonly property int checkOutPopupHeaderHeight: (5/100)*refScreenHeight

    // Button width:
    readonly property int buttonWidth: (264/refScreenWidth)*Screen.desktopAvailableWidth
    readonly property int buttonHeight: (64/refScreenHeight)*Screen.desktopAvailableHeight

    // Labels:
    readonly property string addToCartText: qsTr("ADD TO CART")

    // Floating z max:
    readonly property int zMax: 1e6
}
