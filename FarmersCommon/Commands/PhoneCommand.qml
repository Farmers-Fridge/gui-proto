import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "takePhone"
    property string phoneNumber: ""

    // Execute:
    function execute()
    {
        /* TO DO
        var params = "phoneNumber=" + phoneNumber
        console.log("RUNNING COMMAND: " + _restOrder + " USING EMAIL: " + phoneNumber)
        post(params)
        */
    }
}
