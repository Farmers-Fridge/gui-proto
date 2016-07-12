import QtQuick 2.0
import Common 1.0
import "../.."

MenuPageTemplate {
    id: checkOutPage
    homeVisible: true
    pigVisible: true
    cartVisible: true

    // Go to previous page:
    onTabClicked: pageMgr.loadPreviousPage()

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // Cart view:
    topContents: CartView {
        id: cartView
        anchors.fill: parent
    }

    // Bottom contents:
    bottomContents: TotalView {
        id: totalView
        anchors.fill: parent
        subTotal: "$ " + Math.round(_cartModel.cartSubTotal*100)/100
        tax: "$" + Math.round(_cartModel.cartTax*100)/100
        total: "$" + Math.round((_cartModel.cartSubTotal + _cartModel.cartTax)*100)/100
        cartCount: _cartModel.cartCount +
            (_cartModel.cartCount > 0 ? qsTr(" Items") : qsTr(" Item"))
    }
}

