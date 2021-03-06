import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.XmlListModel 2.0
import QtQuick.Controls.Styles 1.4
import Common 1.0
import "../../.."

PageTemplate {
    headerVisible: false

    // Pig clicked:
    function onPigClicked()
    {
        _pageMgr.loadPreviousPage()
    }

    // Table view:
    contents: Item {
        anchors.fill: parent

        // Icon:
        Image {
            id: logo
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/assets/ico-logo.png"
            asynchronous: true
        }

        // Table view:
        CustomTableView {
            id: tableView
            width: parent.width
            height: parent.height/2
            anchors.centerIn: parent
            targetUrl: _appData.serverInfo.httpPrefix + getPageSettingsById("STATS_SYSTEM_HEALTH_PAGE").systemHealthPageUrl
            targetColumns: getPageSettingsById("STATS_SYSTEM_HEALTH_PAGE").targetSystemHealthColumns
            updateTime: getPageSettingsById("STATS_SYSTEM_HEALTH_PAGE").systemHealthPageUpdateTime
        }
    }

    // Initialize:
    function initialize()
    {
        tableView.start()
    }

    // Finalize:
    function finalize()
    {
        tableView.stop()
    }
}

