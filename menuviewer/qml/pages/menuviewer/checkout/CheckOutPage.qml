import QtQuick 2.5
import Common 1.0
import "../../.."

PageTemplate {
    id: checkOutPage

    // 0: email request
    // 1: coupon request
    property int requestType: 0

    // Go to previous page:
    onTabClicked: pageMgr.loadPreviousPage()

    // OK clicked:
    function onOKClicked(enteredText)
    {
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
        notepad.notepadLabel = qsTr("Please Enter Coupon Code")
    }

    // Email clicked:
    function onEmailClicked()
    {
        requestType = 0
        notepad.invoker = checkOutPage
        notepad.state = "on"
        notepad.notepadLabel = qsTr("Please Enter a Valid Email Address")
    }

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // Contents:
    contents: Item {
        anchors.fill: parent

        // Cart view:
        Rectangle {
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: totalView.top
            color: "transparent"
            // Cart view:
            CartView {
                id: cartView
                anchors.fill: parent
                anchors.margins: 4
            }
        }

        // Separator:
        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: totalView.top
            color: _colors.ffColor7
        }

        // Bottom contents:
        TotalView {
            id: totalView
            width: parent.width
            height: parent.height*.15
            anchors.bottom: parent.bottom
            subTotal: "$ " + Math.round(_cartModel.cartSubTotal*100)/100
            tax: "$" + Math.round(_cartModel.cartTax*100)/100
            total: "$" + Math.round((_cartModel.cartSubTotal + _cartModel.cartTax)*100)/100
            cartCount: _cartModel.cartCount +
                (_cartModel.cartCount > 1 ? qsTr(" Items") : qsTr(" Item"))
        }
    }
}

