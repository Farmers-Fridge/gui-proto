import QtQuick 2.5
import ".."

Command {
    id: exitCommand

    // Execute:
    function execute()
    {
        mainApplication.showPopup("_checkout_")
    }
}
