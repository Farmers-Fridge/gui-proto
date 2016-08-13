import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

Page {
    property int centralAreaWidth: parent.width/2
    property int centralAreaHeight: parent.height/2

    Column {
        id: col
        width: centralAreaWidth
        height: centralAreaHeight
        anchors.centerIn: parent
        spacing: 64
        Repeater {
            model: _appData.workflows.length
            LargeButton {
                id: button
                width: centralAreaWidth
                height: 128
                text: _appData.workflows[index].name
                iconSource: _appData.workflows[index].icon
                onButtonClicked: {
                    _currentWorkflowIndex = index
                    mainApplication.loadNextPage()
                }
            }
        }
    }

    // Initial page:
    function isInitialPage()
    {
        return true
    }

    // Return next page id:
    function nextPageId()
    {
        console.log("ICI: _currentWorkflowIndex = ", _currentWorkflowIndex)
        if (_currentWorkflowIndex === 0)
        {
            return "SYSTEM_HEALTH"
        }
        else
        if (_currentWorkflowIndex === 1)
        {
            return "ROUTE"
        }
        else
        if (_currentWorkflowIndex === 2)
        {
            return "STATISTICS"
        }
    }
}

