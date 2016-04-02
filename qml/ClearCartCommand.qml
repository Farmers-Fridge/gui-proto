import QtQuick 2.4

Command {
    id: clearCartCommand

    // Execute:
    function execute()
    {
        _controller.clearCart()
    }
}
