import QtQuick 2.5
import ".."
import Components 1.0
import Commands 1.0

RestCommand {
    _restOrder: "restockFromTablet"
    property string modifiedStockItems: ""

    // Execute:
    function execute()
    {
        var params = modifiedStockItems
        console.log("RUNNING COMMAND: ", _restOrder)
        post(params)
    }
}


