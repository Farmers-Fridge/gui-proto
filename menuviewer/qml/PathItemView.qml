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

        // Get menu image url:
        function getMenuImageUrl()
        {
            var source = ""

            // Off line:
            if (_appData.offline_mode === "1")
            {
                // TO DO
                source = _controller.fromLocalFile(_controller.offLinePath + "/" + targetCategory + "/Square Thumbnails/" + icon)
            }
            else
            // In line:
            {
                source = Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
            }

            return source
        }

        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height
        menuImageUrl: getMenuImageUrl()
        //nutritionFactImageUrl: Utils.urlPublicStatic(_appData.urlPublicRootValue, nutrition)
        nutritionFactImageUrl: "qrc:/assets/Carousel Images Empty Plate.png"

        // Show nutritional info:
        function onShowNutritionalInfo()
        {
            // Delegate available:
            if (imageDelegate)
            {
                // Front image ready:
                if (frontImageReady)
                {
                    // This is current category:
                    if (targetCategory === _controller.currentCategory)
                    {
                        visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%pathView.model.count
                        if (index === visibleIndex)
                            imageDelegate.flip()
                    }
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
        if (targetCategory === _controller.currentCategory)
        {
            var incr = 1
            var currentIndex = pathView.currentIndex
            currentIndex -= incr
            pathView.gotoIndex(currentIndex)

            // Set visible item:
            visibleIndex = pathView.currentIndex%model.count

            // Set current menu item:
            currentMenuItem = categoryListModel.get(visibleIndex)
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

            // Set visible index:
            visibleIndex = (pathView.currentIndex+pathView.pathItemCount)%model.count

            // Set current menu item:
            currentMenuItem = categoryListModel.get(visibleIndex)
        }
    }

    // Add current item to cart:
    function onAddCurrentItemToCart()
    {
        if (targetCategory === _controller.currentCategory)
        {
            // Run add to cart command:
            visibleIndex = (pathView.currentIndex+pathView.pathItemCount-1)%model.count
            if (visibleIndex >= 0)
            {
                _addToCartCommand.currentItem = categoryListModel.get(visibleIndex)
                _addToCartCommand.execute()
            }
        }
    }

    // Model ready:
    function onModelReady()
    {
        currentMenuItem = categoryListModel.get(1)
    }

    Component.onCompleted: {
        mainApplication.addCurrentItemToCart.connect(onAddCurrentItemToCart)
    }
}
