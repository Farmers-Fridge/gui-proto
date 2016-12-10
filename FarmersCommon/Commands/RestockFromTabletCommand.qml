import QtQuick 2.5
import ".."

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


