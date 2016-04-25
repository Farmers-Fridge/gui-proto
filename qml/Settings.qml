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

    // Main window color:
    readonly property string mainWindowColor: "#d5d6d8"

    // Used for CommonText element:
    readonly property string fontFamily: "Courrier New"

    // Popup:
    readonly property string popupBkgColor: "ivory"

    // Application green:
    readonly property string green: "darkgreen"

    // Checkout popup header height:
    readonly property int checkOutPopupHeaderHeight: (5/100)*refScreenHeight

    // Selected/Unselected category colors:
    readonly property string selectedCategoryBkgColor: "#6ca426"

    // Line color:
    readonly property string lineColor: "#757365"

    // Button width:
    readonly property int buttonWidth: (264/refScreenWidth)*Screen.desktopAvailableWidth
    readonly property int buttonHeight: (64/refScreenHeight)*Screen.desktopAvailableHeight

    // Labels:
    readonly property string addToCartText: qsTr("ADD TO CART")

    // Page transition delay:
    readonly property int pageTransitionDelay: 500

    // Idle time out:
    readonly property int idleTimeOut: 3000

    // Page idle time:
    readonly property int pageIdleTime: 15000

    // Floating z max:
    readonly property int zMax: 1e6

    // Network time out:
    readonly property int networkTimeOut: 15000

    // Cart view header color:
    readonly property string cartViewHeaderColor: "brown"
}
