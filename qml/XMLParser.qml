import QtQuick 2.5

Item {
    property string url
    signal dataReady(string responseText)

    function request(url) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
                dataReady(xhr.responseText)
        }
        xhr.open("GET", url, true)
        xhr.send("")
    }

    // Url changed:
    onUrlChanged: request(url)
}
