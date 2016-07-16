import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "updateRestockExceptions"
    _networkIP: _controller.currentNetworkIP

    property string row: ""
    property string column: ""
    property string theoExpired: ""
    property string theoAdds: ""
    property string userActualPar: ""
    property string theoPar: ""

    // Execute:
    function execute()
    {
        var actualPulls = theoExpired
        var actualStocks = theoAdds
        var delta = theoPar - userActualPar
        var reason = "na"
        if (userActualPar !== theoPar) {
            if (theoAdds >= delta) {
                actualStocks = theoAdds - delta
            } else {
                actualStocks = 0
                actualPulls = theoExpired + (delta - theoAdds)
            }
            /*
            if (kitchenShort) {
                reason = "Kitchen Short"
                if (theoAdds >= delta) {
                    actualStocks = theoAdds - delta
                } else {
                    actualStocks = 0
                    actualPulls = theoExpired + (delta - theoAdds)
                }
            }
            if (machineShort) {
                reason = "Machine Short"
                actualPulls = theoExpired + delta
            }
            */
        }

        var totalPulls = actualPulls
        var totalStocks = actualStocks

        var params = "row=" + row + "&column=" + column + "&totalPulls=" + totalPulls + "&totalStocks=" + totalStocks + "&reason=" + reason
        post(params)
    }
}


