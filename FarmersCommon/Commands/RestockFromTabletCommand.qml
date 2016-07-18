import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "restockFromTablet"
 
    // Execute:
    function execute()
    {
        var params = ""
        console.log("RUNNING COMMAND: ", _restOrder)
        post(params)
    }
}


