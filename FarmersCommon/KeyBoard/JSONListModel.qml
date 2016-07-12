import QtQuick 2.5
import Common 1.0

Item {
    property string source: ""
    property string json: ""
    property string query: ""
    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count
    signal modelReady()

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE)
            {
                json = xhr.responseText;
            }
        }
        xhr.send();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);
        for ( var key in objectArray ) {
            var jo = objectArray[key];
            jsonModel.append( jo );
        }

        modelReady()
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
        {
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);
        }

        return objectArray;
    }
}
