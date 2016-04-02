import QtQuick 2.4
import ".."

RestCommand {
    _restOrder: "takeReceiptEmailAddress"
    property string emailAddress: ""

    // Execute:
    function execute()
    {
        var params = "emailAddress=" + emailAddress
        console.log("RUNNING COMMAND: " + _restOrder + " USING EMAIL: " + emailAddress)
        post(params)
    }
}
