import QtQuick 2.5
import Common 1.0
import "../../.."

PageTemplate {
    id: checkOutPage

    // 0: email request
    // 1: coupon request
    property int requestType: 0

    // Go to previous page:
    onTabClicked: _pageMgr.loadPreviousPage()

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

            // Hide notepad:
            _notepad.state = ""
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

            // Hide notepad:
            _notepad.state = ""
        }
        else
        // Phone request:
        if (requestType === 2)
        {
            // Set phone number:
            _phoneCommand.phoneNumber = enteredText

            // Execute:
            _phoneCommand.execute()

            // Hide keypad:
            _privateNumericKeyPad.state = ""
        }
    }

    // Coupon clicked:
    function onCouponClicked()
    {
        requestType = 1
        _notepad.invoker = checkOutPage
        _notepad.state = "on"
        _notepad.notepadLabel = qsTr("Please Enter Coupon Code")
    }

    // Tractor clicked:
    function onTractorClicked()
    {
        requestType = 2
		_privateNumericKeyPad.maxChar = 11
        _privateNumericKeyPad.textInputSize = 32
        _privateNumericKeyPad.invoker = checkOutPage
        _privateNumericKeyPad.state = "on"
    }

    // Email clicked:
    function onEmailClicked()
    {
        requestType = 0
        _notepad.invoker = checkOutPage
        _notepad.state = "on"
        _notepad.notepadLabel = qsTr("Please Enter a Valid Email Address")
    }

    // Pig clicked:
    function onPigClicked()
    {
        _pageMgr.loadPreviousPage()
    }

    // Cart clicked:
    function onCartClicked()
    {
        _cartSummaryDialog.state = "on"
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

