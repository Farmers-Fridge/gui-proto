import QtQuick 2.5
import ".."

RestCommand {
    _restOrder: "restockFromTablet"
    _networkIP: _controller.currentNetworkIP

    // Execute:
    function execute()
    {
        var params = ""
        mainWindow.logMessage("RUNNING COMMAND: ", _restOrder)
        post(params)
    }
}


