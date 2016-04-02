import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import "script/Utils.js" as Utils

// XML version model:
XmlListModel {
    id: categoryListModel
    property string targetCategory: ""
    source: Utils.urlPlay(_appData.categoryListSource + "?category=" + targetCategory)
    query: _appData.categoryListQuery
    signal modelReady()

    XmlRole { name: "vendItemName"; query: "vendItemName/string()"; isKey: true }
    XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
    XmlRole { name: "nutrition"; query: "nutrition/string()"; isKey: true }
    XmlRole { name: "category"; query: "category/string()"; isKey: true }
    XmlRole { name: "price"; query: "price/string()"; isKey: true }

    onStatusChanged: {
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


