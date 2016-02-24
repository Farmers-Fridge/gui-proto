import QtQuick 2.4
import ".."

Command {
    id: exitCommand

    // Execute:
    function execute()
    {
        mainApplication.showPopup("_checkout_")
    }
}
