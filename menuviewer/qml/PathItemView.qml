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

    // Delegate:
    delegate: SingleItemView {
        id: imageDelegate
        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height
        menuImageUrl: Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
        nutritionFactImageUrl: Utils.urlPublicStatic(_appData.urlPublicRootValue, nutrition)
        itemPrice: price

        // Show nutritional info:
        function onShowNutritionalInfo()
        {
            if ((typeof(_controller) !== "undefined") && frontImageReady)
            {
                if (targetCategory === _controller.currentCategory)
                {
                    visibleIndex = (pathView.currentIndex+1)%(pathView.model.count)
                    if (index === visibleIndex)
                        imageDelegate.flip()
                }
            }
        }

        Component.onCompleted: {
            mainApplication.showNutritionalInfo.connect(onShowNutritionalInfo)
        }
    }

    // Navigation arrows:
    Item {
        width: parent.width
        height: containerHeight
        anchors.centerIn: parent
        visible: categoryListModel.count > 1

        // Navigation left:
        ImageButton {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assets/ico-nav-left.png"
            onClicked: mainApplication.navigateLeft()
        }

        // Navigation right:
        ImageButton {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assets/ico-nav-right.png"
            onClicked: mainApplication.navigateRight()
        }
    }

    // Go to specific index:
    function gotoIndex(idx) {
        pathView.currentIndex = idx
    }

    // Navigate left:
    function onNavigateLeft()
    {
        if (targetCategory === _controller.currentCategory)
        {
            var incr = 1
            var currentIndex = pathView.currentIndex
            currentIndex -= incr
            pathView.gotoIndex(currentIndex)

            // Define visible index:
            visibleIndex = pathView.currentIndex%model.count
        }
    }

    // Navigate right:
    function onNavigateRight()
    {
        if (targetCategory === _controller.currentCategory)
        {
            var incr = 1
            var currentIndex = pathView.currentIndex
            currentIndex += incr
            pathView.gotoIndex(currentIndex)

            // Define visible index:
            visibleIndex = (pathView.currentIndex+pathView.pathItemCount)%model.count
        }
    }

    // Add current item to cart:
    function onAddCurrentItemToCart()
    {
        if (targetCategory === _controller.currentCategory)
        {
            // Run add to cart command:
            visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%model.count
            _addToCartCommand.currentItem = categoryListModel.get(visibleIndex)
            _addToCartCommand.execute()
        }
    }

    // Handle navigation:
    Component.onCompleted: {
        mainApplication.navigateLeft.connect(onNavigateLeft)
        mainApplication.navigateRight.connect(onNavigateRight)
        mainApplication.addCurrentItemToCart.connect(onAddCurrentItemToCart)
    }
}
