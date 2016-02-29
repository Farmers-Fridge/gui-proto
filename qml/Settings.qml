import QtQuick 2.4
import QtQuick.Window 2.2

Item {
    // Enter reference screen size:
    readonly property int refScreenWidth: 1280
    readonly property int refScreenHeight: 1920

    // Get screen size:
    readonly property int screenWidth: Screen.desktopAvailableWidth
    readonly property int screenHeight: Screen.desktopAvailableHeight

    onScreenWidthChanged: console.log("SCREEN WIDTH: ", screenWidth)
    onScreenHeightChanged: console.log("SCREEN HEIGHT: ", screenHeight)

    // Return scaled width:
    function scaledWidth(width)
    {
        return (width/refScreenWidth)*screenWidth
    }

    // Return scaled height:
    function scaledHeight(height)
    {
        return (height/refScreenHeight)*screenHeight
    }

    // Menu view top area height:
    readonly property int menuViewTopAreaHeight: scaledHeight(refScreenHeight-1200)

    // Main window color:
    readonly property string mainWindowColor: "#d5d6d8"

    // Used for CommonText element:
    readonly property int fontSize: 20
    readonly property string fontFamily: "Comic Sans MS"
    readonly property string textColor: "black"

    // Cart view:
    readonly property int cartViewDelegateHeight: scaledHeight(400)

    // Popup:
    readonly property string popupBkgColor: "ivory"

    // Shopping cart:
    readonly property string shoppingCartTitle: qsTr("Your Shopping Cart")

    // Application green:
    readonly property string appGreen: "darkgreen"

    // Nutrition fact timeout:
    readonly property int nutritionFactTimer: 5000

    // Checkout popup header height:
    readonly property int checkOutPopupHeaderHeight: 96

    // Image width:
    readonly property int gridImageWidth: scaledWidth(213)

    // Image height:
    readonly property int gridImageHeight: scaledHeight(565)
}
