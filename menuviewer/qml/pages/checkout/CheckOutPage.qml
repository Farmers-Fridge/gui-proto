import QtQuick 2.0
import Common 1.0
import "../.."

MenuPageTemplate {
    id: checkOutPage
    homeVisible: true
    emailVisible: true
    couponVisible: true
    pigVisible: true
    cartVisible: true

    // 0: email request
    // 1: coupon request
    property int requestType: 0

    // Go to previous page:
    onTabClicked: pageMgr.loadPreviousPage()

    // OK clicked:
    function onOKClicked(enteredText)
    {
        console.log("REQUEST TYPE = ", requestType)

        // Email request:
        if (requestType === 0)
        {
            if (_controller.validateEmailAddress(enteredText))
            {
                _takeReceiptEmailAddressCommand.emailAddress = enteredText
                _takeReceiptEmailAddressCommand.execute()
            }
        }
        else
        // Coupon request:
        if (requestType === 1)
        {
            if (enteredText.length > 0)
            {
                _takeCouponCodeCommand.couponCode = enteredText
                _takeCouponCodeCommand.execute()
            }
        }

        // Hide notepad:
        notepad.state = ""
    }

    // Coupon clicked:
    function onCouponClicked()
    {
        requestType = 1
        notepad.invoker = checkOutPage
        notepad.state = "on"
    }

    // Email clicked:
    function onEmailClicked()
    {
        requestType = 0
        notepad.invoker = checkOutPage
        notepad.state = "on"
    }

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    /* TO DO
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
    */
}

