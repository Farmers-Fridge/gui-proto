import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "takeReceiptEmailAddress"
    _networkIP: _appData.currentIP
    property string emailAddress: ""

    // Execute:
    function execute()
    {
        var params = "emailAddress=" + emailAddress
        console.log("RUNNING COMMAND: " + _restOrder + " USING EMAIL: " + emailAddress)
        post(params)
    }
}
