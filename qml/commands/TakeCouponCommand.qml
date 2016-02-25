import QtQuick 2.4
import ".."

RestCommand {
    _restOrder: "takeCouponCode"
    property string couponCode: ""

    // Execute:
    function execute()
    {
        var params = "couponCode=" + couponCode
        console.log("RUNNING COMMAND: " + _restOrder + " USING COUPON CODE: " + couponCode)
        post(params)
    }
}


