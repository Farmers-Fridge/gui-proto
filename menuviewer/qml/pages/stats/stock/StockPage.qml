import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0

Page {
    id: stockPage

    // Final page?
    function isFinalPage()
    {
        return true
    }

    // Setup page:
    function initialize()
    {
        pageLoader.sourceComponent = pageComponent
    }

    // Page loader:
    Loader {
        id: pageLoader
        anchors.fill: parent
        onLoaded: item.initialize()
    }

    // Page component:
    Component {
        id: pageComponent
        StockPagePrivate {
            id: stockPagePrivate
            width: stockPage.width
            height: stockPage.height
            opacity: 1
        }
    }
}
