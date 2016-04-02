import QtQuick 2.5

Page {
    pageId: "_idle_"

    // Main timer (debug only):
    Timer {
        id: timer
        interval: _settings.idleTimeOut
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

    CommonText {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        color: _settings.green
        text: qsTr("Touch Screen To Start")
        font.pixelSize: 42
    }

    MouseArea {
        anchors.fill: parent
        onClicked: mainApplication.loadPage(_pageMgr.previousPage)

        // Cancel button:
        MouseArea {
            id: cancelButton
            width: 96
            height: 96
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            onClicked: mainApplication.showKeyPad()
        }
    }
}

