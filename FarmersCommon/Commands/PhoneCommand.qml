import QtQuick 2.5

RestCommand {
    _restOrder: "takePhone"
    property string phoneNumber: ""

    // Execute:
    function execute()
    {
        var params = "phone=" + phoneNumber
        console.log("RUNNING COMMAND: " + _restOrder + " USING PHONE NUMBER: " + phoneNumber)
        post(params)
    }
}
