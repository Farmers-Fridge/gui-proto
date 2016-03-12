import QtQuick 2.4
import QtQuick.Window 2.2

Item {
    // Enter reference screen size:
    readonly property int refScreenWidth: 1280
    readonly property int refScreenHeight: 1920
    readonly property int viewAreaHeight: (60/100)*refScreenHeight

    // Menu view top area height:
    readonly property double toolbarHeightRatio: .1

    // Main window color:
    readonly property string mainWindowColor: "#d5d6d8"

    // Used for CommonText element:
    readonly property int pixelSize: 24
    readonly property string fontFamily: "Comic Sans MS"
    readonly property string textColor: "black"

    // Cart view:
    readonly property int cartViewDelegateHeight: gridImageHeight

    // Popup:
    readonly property string popupBkgColor: "ivory"

    // Shopping cart:
    readonly property string shoppingCartTitle: qsTr("Your Fresh Market")

    // Application green:
    readonly property string appGreen: "darkgreen"

    // Checkout popup header height:
    readonly property int checkOutPopupHeaderHeight: (5/100)*refScreenHeight

    // Image width:
    readonly property int gridImageWidth: Math.min(refScreenWidth/3, viewAreaHeight/3)
    onGridImageWidthChanged: console.log(gridImageWidth)

    // Image height:
    readonly property int gridImageHeight: gridImageWidth
    onGridImageHeightChanged: console.log(gridImageHeight)
}
