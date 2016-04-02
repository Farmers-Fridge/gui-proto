import QtQuick 2.4
import QtQuick.Window 2.2

Item {
    // Main title:
    property string mainTitle: qsTr("CHOOSE CATEGORY & SELECT ITEMS")

    // Enter reference screen size:
    readonly property int refScreenWidth: 1280
    readonly property int refScreenHeight: 1920
    readonly property int viewAreaHeight: (60/100)*refScreenHeight

    // Menu view top area height:
    readonly property double toolbarHeightRatio: .1

    // Main window color:
    readonly property string mainWindowColor: "#d5d6d8"

    // Used for CommonText element:
    readonly property string fontFamily: "Courrier New"

    // Cart view:
    readonly property int cartViewDelegateHeight: gridImageHeight

    // Popup:
    readonly property string popupBkgColor: "ivory"

    // Shopping cart:
    readonly property string shoppingCartTitle: qsTr("Your Fresh Market")

    // Application green:
    readonly property string green: "darkgreen"

    // Checkout popup header height:
    readonly property int checkOutPopupHeaderHeight: (5/100)*refScreenHeight

    // Image width:
    readonly property int gridImageWidth: Math.min(refScreenWidth/3.2, viewAreaHeight/3.2)

    // Image height:
    readonly property int gridImageHeight: gridImageWidth

    // Selected/Unselected category colors:
    readonly property string selectedCategoryBkgColor: "#6ca426"
    readonly property string unSelectedCategoryBkgColor: green

    // Line color:
    readonly property string lineColor: "#757365"

    // Button width:
    readonly property int buttonWidth: 264
    readonly property int buttonHeight: 64

    // Labels:
    readonly property string returnToSaladsText: qsTr("RETURN TO SALADS")
    readonly property string addToCartText: qsTr("ADD TO CART")
}
