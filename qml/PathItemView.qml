import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import "script/Utils.js" as Utils

// Path view:
PathView {
    id: pathView
    pathItemCount: 2
    highlightRangeMode: PathView.StrictlyEnforceRange
    snapMode: ListView.SnapOneItem
    interactive: false
    property int containerWidth: .75*width
    property int containerHeight: .75*height

    // Single item path:
    Component {
        id: singleItemPathComponent
        Path {
            startX: pathView.width/2; startY: pathView.height/2
            PathLine {x: pathView.width + pathView.width/2; y: pathView.height/2 }
        }
    }

    // Multiple item path:
    Component {
        id: multipleItemPathComponent
        Path {
            startX: -pathView.width/2; startY: pathView.height/2
            PathLine {x: pathView.width + pathView.width/2; y: pathView.height/2 }
        }
    }

    // Path loader:
    Loader {
        id: pathLoader
        sourceComponent: categoryListModel.count > 1 ? multipleItemPathComponent : singleItemPathComponent
        onLoaded: pathView.path = item
    }

    // Delegate:
    delegate: SingleItemView {
        id: imageDelegate
        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height
        itemUrl: Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
        itemPrice: price
    }

    // Navigation arrows:
    Item {
        width: parent.width
        height: containerHeight
        anchors.centerIn: parent
        visible: categoryListModel.count > 1

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
