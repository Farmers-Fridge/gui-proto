import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.XmlListModel 2.0
import QtQuick.Controls.Styles 1.4
import Common 1.0
import "../.."

Page {
    // Table view:
    CustomTableView {
        id: tableView
        anchors.fill: parent
        targetUrl: _appData.httpPrefix + _appData.systemHealthPageUrl
        targetColumns: _appData.targetSystemHealthColumns
        updateTime: _appData.systemHealthPageUpdateTime
    }

    // Is final page?
    function isFinalPage()
    {
        return true
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

