import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import "script/Utils.js" as Utils

// Path view:
PathView {
    id: pathView
    pathItemCount: 2
    anchors.fill: parent
    highlightRangeMode: PathView.StrictlyEnforceRange
    snapMode: ListView.SnapOneItem
    interactive: false
    property int containerWidth: .75*width
    property int containerHeight: .75*height

    // Path:
    path: Path {
        startX: -width/2; startY: height/2
        PathLine {x: width + width/2; y:height/2 }
    }

    // Delegate:
    delegate: SingleItemView {
        id: imageDelegate
        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height
        imageUrl: icon !== "" ? Utils.urlPublicStatic(_appData.urlPublicRootValue, icon) : ""

    }

    // Navigation arrows:
    Item {
        width: parent.width
        height: containerHeight
        anchors.centerIn: parent

        // Previous button:
        CircularButton {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-prev.png"
            onClicked: mainApplication.navigateLeft()
            imageOffset: -8
        }

        // Next button:
        CircularButton {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-next.png"
            onClicked: mainApplication.navigateRight()
            imageOffset: 8
        }
    }

    // Go to specific index:
    function gotoIndex(idx) {
        pathView.currentIndex = idx
    }

    // Navigate left:
    function onNavigateLeft()
    {
        var incr = 1
        var currentIndex = pathView.currentIndex
        currentIndex -= incr
        pathView.gotoIndex(currentIndex)
    }

    // Navigate right:
    function onNavigateRight()
    {
        var incr = 1
        var currentIndex = pathView.currentIndex
        currentIndex += incr
        pathView.gotoIndex(currentIndex)
    }

    // Handle navigation:
    Component.onCompleted: {
        mainApplication.navigateLeft.connect(onNavigateLeft)
        mainApplication.navigateRight.connect(onNavigateRight)
    }
}
