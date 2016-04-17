import QtQuick 2.5
import "script/Utils.js" as Utils

Command {
    // Id:
    property string _restOrder: ""

    // IP address:
    property string _networkIP: ""

    // Post:
    function post(params) {
        _appIsBusy = true
        var http = new XMLHttpRequest()
        var url = Utils.urlPlay(_networkIP, "/post/" + _restOrder);
        http.open("POST", url, true);

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            _appIsBusy = false
            console.log("USED PARAMETERS: ")
            console.log(params)
            if (http.readyState === 4) {
                if (http.status === 200) {
                    console.log("RESPONSE TO REST ORDER: " + _restOrder + " IS: " + http.responseText)
                    cmdSuccess(http.responseText)
                } else {
                    console.log("ERROR FROM REST ORDER: " + _restOrder + " IS: " + http.status)
                    cmdError(_restOrder + " COMMAND REST ERROR: " + http.status)
                }
            }
        }
        http.send(params);
    }
}
