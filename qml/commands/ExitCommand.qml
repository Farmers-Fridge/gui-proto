import QtQuick 2.5
import ".."

Command {
    id: exitCommand

    // Execute:
    function execute()
    {
        Qt.quit()
    }
}
