import QtQuick 2.5
import ".."

Command {
    id: clearCartCommand

    // Execute:
    function execute()
    {
        _controller.clearCart()
    }
}
