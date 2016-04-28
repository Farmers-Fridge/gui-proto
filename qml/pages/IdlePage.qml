import QtQuick 2.5
import "../script/Utils.js" as Utils
import ".."

Page {
    pageId: "_idlepage_"

    // Main timer (debug only):
    Timer {
        id: timer
        interval: _timeSettings.idlePageImageTimeOut
        repeat: true
        running: _pageMgr.enabled
        onTriggered: idleView.currentIndex++
    }

    // Path view:
    PathView {
        id: idleView
        pathItemCount: 2
        model: _controller.saladAssets
        anchors.fill: parent
        highlightRangeMode: PathView.StrictlyEnforceRange
        snapMode: ListView.SnapOneItem
        interactive: false

        // Path:
        path: Path {
            startX: -width/2; startY: height/2
            PathLine {x: width + width/2; y:height/2 }
        }

        delegate: Item {
            width: parent.width
            height: parent.height
            Image {
                anchors.centerIn: parent
                source: _controller.saladAssets[index]
            }
        }
    }

    // Touch screen to start text:
    CommonText {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        color: _colors.ffDarkGreen
        text: qsTr("Touch Screen To Start")
        font.pixelSize: 42
    }

    // Clicking anywhere loads previous page:
    MouseArea {
        anchors.fill: parent
        onClicked: mainApplication.loadPage("_menupage_")
    }
}

