import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0

// XML version model:
CustomXmlListModel {
    id: categoryListModel

    // Get source:
    function getCategoryListSource()
    {
        var source = ""

        // Off line:
        if (_appData.offline_mode === "1")
        {
            // TO DO
            source = _controller.fromLocalFile(_controller.offLinePath + "/" + targetCategory + "/" + targetCategory)
        }
        // In line:
        else
        {
            source = Utils.urlPlay(_appData.currentIP, _appData.categoryListSource + "?category=" + targetCategory)
        }

        return source
    }

    property string targetCategory: ""
    source: getCategoryListSource()
    query: _appData.categoryListQuery
    signal modelReady()

    XmlRole { name: "vendItemName"; query: "vendItemName/string()"; isKey: true }
    XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
    XmlRole { name: "nutrition"; query: "nutrition/string()"; isKey: true }
    XmlRole { name: "category"; query: "category/string()"; isKey: true }
    XmlRole { name: "price"; query: "price/string()"; isKey: true }

    onStatusChanged: {
        _appIsBusy = (status === XmlListModel.Loading)
        if (status !== XmlListModel.Loading)
        {
            if (status === XmlListModel.Error)
                // Failure:
                console.log("FAILED TO LOAD IMAGES FOR CATEGORY: " + targetCategory)
            else
            if (status === XmlListModel.Ready)
            {
                // Success:
                console.log("IMAGES FOR CATEGORY: " + targetCategory + " LOADED SUCCESSFULLY")
                modelReady()
            }
        }
    }
}


