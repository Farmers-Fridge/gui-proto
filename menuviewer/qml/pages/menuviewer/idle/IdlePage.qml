import QtQuick 2.5
import Common 1.0
import "../../.."

PageTemplate {
    id: idlePage
    headerVisible: false
    footerVisible: false
    property int timerDuration: 500

    // Main timer:
    Timer {
        id: timer
        interval: _settings.idlePageTimeOut
        repeat: true
        running: true
        onTriggered: idleView.currentIndex++
    }

    // Path view:
    PathView {
        id: idleView
        pathItemCount: 2
        model: _controller.saladAssets
        anchors.top: parent.top
        anchors.bottom: informationArea.top
        width: parent.width
        highlightRangeMode: PathView.StrictlyEnforceRange
        snapMode: ListView.SnapOneItem
        interactive: false
        clip: true

        // Path:
        path: Path {
            startX: -idleView.width/2; startY: idleView.height/2
            PathLine {x: idleView.width + idleView.width/2; y: idleView.height/2 }
        }

        delegate: Item {
            width: idleView.width
            height: idleView.height
            Image {
                asynchronous: true
                height: parent.height*2/3
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: _controller.saladAssets[index]
            }
        }
    }

    // Information area:
    Rectangle {
        id: informationArea
        color: _colors.ffColor16
        border.color: _colors.ffColor3
        border.width: 3
        width: parent.width
        height: 64
        anchors.bottom: parent.bottom

        // Retrieving server data:
        StandardText {
            id: info1
            anchors.centerIn: parent
            color: _colors.ffColor15
            text: qsTr("Retrieving server data...")
            visible: !_controller.serverDataRetrieved
        }

        // Touch screen to start text:
        StandardText {
            id: info2
            anchors.centerIn: parent
            color: _colors.ffColor3
            text: qsTr("Touch Screen To Start")
            visible: _controller.serverDataRetrieved
        }
    }

    // Return next page id:
    function nextPageId()
    {
        return "MENU_PRESENTATION_PAGE"
    }

    // Clicking anywhere loads previous page:
    MouseArea {
        anchors.fill: parent
        enabled: _controller.serverDataRetrieved
        onClicked: pageMgr.loadNextPage()
    }
}
