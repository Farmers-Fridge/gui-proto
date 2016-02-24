import QtQuick 2.4
import QtQuick.Window 2.2

Item {
    // Enter reference screen size:
    readonly property int refScreenWidth: 1280
    readonly property int refScreenHeight: 1920

    // Get screen size:
    readonly property int screenWidth: Screen.desktopAvailableWidth
    readonly property int screenHeight: Screen.desktopAvailableHeight

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
    readonly property int menuViewTopAreaHeight: scaledHeight(320)

    // Main window color:
    readonly property string mainWindowColor: "#d5d6d8"

    // Used for CommonText element:
    readonly property int fontSize: 20
    readonly property string fontFamily: "Comic Sans MS"
    readonly property string textColor: "black"

    // Cart view:
    readonly property int cartViewDelegateHeight: scaledHeight(400)
    readonly property string cartViewBorderColor: appGreen

    // Popup:
    readonly property string popupBkgColor: "ivory"

    // Shopping cart:
    readonly property string shoppingCartTitle: qsTr("Your Shopping Cart")

    // Application green:
    readonly property string appGreen: "darkgreen"
}