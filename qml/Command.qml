import QtQuick 2.5

Item {
    // Command error:
    signal cmdError(string error)

    // Command success:
    signal cmdSuccess(string response)

    // Base implementation does nothing:
    function execute()
    {

    }
}
