import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0
import "../../.."

PageTemplate {
    // Hide header:
    headerVisible: false

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // Set contents:
    contents: Item {
        anchors.fill: parent

        // Icon:
        Image {
            id: logo
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/assets/ico-logo.png"
        }

        Column {
            id: col
            width: parent.width*3/4
            height: parent.height/2
            anchors.centerIn: parent
            spacing: 64
            Repeater {
                model: _appData.workflows.length
                LargeButton {
                    id: button
                    width: parent.width
                    height: 128
                    text: _appData.workflows[index].name
                    iconSource: _appData.workflows[index].icon
                    onButtonClicked: {
                        _currentWorkflowIndex = index
                        pageMgr.loadNextPage()
                    }
                }
            }
        }
    }

    // Return next page id:
    function nextPageId()
    {
        if (_currentWorkflowIndex === 0)
        {
            return "STATS_SYSTEM_HEALTH_PAGE"
        }
        else
        if (_currentWorkflowIndex === 1)
        {
            return "STATS_ROUTE_PAGE"
        }
        else
        if (_currentWorkflowIndex === 2)
        {
            return "STATS_STATISTICS_PAGE"
        }
    }
}

