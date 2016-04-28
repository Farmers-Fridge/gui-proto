import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "takeCouponCode"
    _networkIP: _appData.currentIP
    property string couponCode: ""

    // Execute:
    function execute()
    {
        var params = "couponCode=" + couponCode
        mainWindow.logMessage("RUNNING COMMAND: " + _restOrder + " USING COUPON CODE: " + couponCode)
        post(params)
    }
}


