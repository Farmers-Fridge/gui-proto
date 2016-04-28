import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import "../script/Utils.js" as Utils
import ".."

Page {
    id: stockPage
    pageId: "_stockpage_"
    idleTime: _timeSettings.pageIdleTime
    signal stopStockPagePrivate()

    // Time out:
    function onIdleTimeOut()
    {
        stopStockPagePrivate()
        mainApplication.loadPreviousPage()
    }

    // Setup page:
    function setup()
    {
        pageLoader.sourceComponent = undefined
        pageLoader.sourceComponent = pageComponent
    }

    // Page loader:
    Loader {
        id: pageLoader
        anchors.fill: parent
    }

    // Page component:
    Component {
        id: pageComponent
        StockPagePrivate {
            id: stockPagePrivate
            width: stockPage.width
            height: stockPage.height
            opacity: 1
            Component.onCompleted: {
                stockPage.stopStockPagePrivate.connect(stockPagePrivate.onStop)
            }
        }
    }
}
