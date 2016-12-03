import QtQuick 2.5
import "../Common/Utils.js" as Utils

Command {
    // Id:
    property string _restOrder: ""

    // IP address:
    property string _networkIP: ""

    // Content type:
    property string _contentType: "application/x-www-form-urlencoded"

    // Post:
    function post(params) {
        var http = new XMLHttpRequest()
        var url = Utils.urlPlay(_networkIP, "/post/" + _restOrder);
        http.open("POST", url, true);

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", _contentType);
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
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
