import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import Common 1.0

// Path view:
PathView {
    id: pathView
    pathItemCount: 2
    highlightRangeMode: PathView.StrictlyEnforceRange
    snapMode: ListView.SnapOneItem
    interactive: false
    property int containerWidth: .75*width
    property int containerHeight: .75*height
    property string targetCategory
    property int visibleIndex: 0

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

    // Current index changed:
    onCurrentIndexChanged: {
        visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%model.count
        _currentMenuItem = categoryListModel.get(visibleIndex).vendItemName
    }

    // Delegate:
    delegate: FlipableNutritionItem {
        id: imageDelegate
        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height
        menuImageUrl: getImageSource(targetCategory, icon, false)
        nutritionFactImageUrl: getImageSource(targetCategory, nutrition, true)

        // Show nutritional info:
        function onShowNutritionalInfo()
        {
            // Delegate available:
            if (imageDelegate)
            {
                // Front image ready:
                if (frontImageReady)
                {
                    visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%pathView.model.count
                    if (index === visibleIndex)
                        imageDelegate.flip()
                }
            }
        }

        Component.onCompleted: mainApplication.showNutritionalInfo.connect(onShowNutritionalInfo)
    }

    // Navigation arrows:
    Item {
        width: Math.min(parent.width, parent.height)
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        z: _settings.zMax
        visible: categoryListModel.count > 1

        // Navigation left:
        ImageButton {
            anchors.right: parent.left
            anchors.rightMargin: -8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assets/ico-nav-left.png"
            onClicked: onNavigateLeft()
        }

        // Navigation right:
        ImageButton {
            anchors.left: parent.right
            anchors.leftMargin: -8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assets/ico-nav-right.png"
            onClicked: onNavigateRight()
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

        // Set visible item:
        visibleIndex = pathView.currentIndex%model.count
    }

    // Navigate right:
    function onNavigateRight()
    {
        var incr = 1
        var currentIndex = pathView.currentIndex
        currentIndex += incr
        pathView.gotoIndex(currentIndex)

        // Set visible index:
        visibleIndex = (pathView.currentIndex+pathView.pathItemCount)%model.count
    }

    // Add current item to cart:
    function onAddCurrentItemToCart()
    {
        // Run add to cart command:
        var pathViewValid = (typeof pathView !== "undefined") && (pathView !== null)
        var modelValid = (typeof model !== "undefined") && (model !== null)
        if (pathViewValid && modelValid)
        {
            visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%model.count
            if (visibleIndex >= 0)
            {
                _addToCartCommand.currentItem = categoryListModel.get(visibleIndex)
                _addToCartCommand.execute()
            }
        }
    }

    Component.onCompleted: {
        mainApplication.addCurrentItemToCart.connect(onAddCurrentItemToCart)
    }
}
