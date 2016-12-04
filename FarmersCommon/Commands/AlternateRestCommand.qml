import QtQuick 2.5
import Components 1.0
import "../Common/Utils.js" as Utils

Command {
    // Id:
    property string _restOrder: ""

    // IP address:
    property string _url: ""

    // Content type:
    property string _contentType: "application/x-www-form-urlencoded"

    // Query:
    property string _query: ""

    // Http post client:
    HttpPostClient {
        id: httpPostClient
        onReplyChanged: {
            if (reply === "ok")
                cmdSuccess(reply)
            else
                cmdError("error")
        }
    }

    // Execute:
    function execute()
    {
        httpPostClient.url = Utils.urlPlay(_url, "/post/" + _restOrder);
        httpPostClient.contentType = _contentType
        httpPostClient.query = _query
        httpPostClient.post()
    }
}
