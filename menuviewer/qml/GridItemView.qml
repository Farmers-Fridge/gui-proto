import QtQuick 2.5
import Common 1.0

GridView {
    id: itemView
    property int gridViewIndex: 0
    property string targetCategory
    signal gridImageClicked(int selectedIndex)

    // Delegate:
    delegate: Item {
        id: imageDelegate
        visible: vendItemName !== ""
        width: itemView.cellWidth
        height: itemView.cellHeight

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: "white"
            anchors.centerIn: parent
            antialiasing: true
            width: height
            height: cellHeight
            visible: originalImage.status !== Image.Ready
            Rectangle {
                color: "darkgreen"
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Get image source:
        function getImageSource()
        {
            var source = ""

            // Off line:
            if (_appData.offline_mode === "1")
            {
                // TO DO
                source = "file:///" + _controller.offLinePath + "/" + targetCategory + "/" + icon
            }
            else
            // In line:
            {
                source = Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
            }

            return source
        }

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            asynchronous: true
            source: imageDelegate.getImageSource()
            cache: true
            fillMode: Image.PreserveAspectFit
            width: height
            height: cellHeight
            anchors.centerIn: parent

            // Busy indicator:
            BusyIndicator {
                id: busyIndicator
                anchors.centerIn: parent
                on: originalImage.status === Image.Loading
                visible: on
            }

            // Handle clicks:
            MouseArea {
                anchors.fill: parent
                onClicked: {
                     gridImageClicked(index-1)
                }
            }

            // Add item to cart:
            ImageButton {
                id: addItem
                anchors.verticalCenter: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 8
                width: 48
                height: 48
                source: "qrc:/assets/ico-add.png"
                onClicked: mainApplication.addCurrentItemToCart()
                visible: originalImage.status === Image.Ready
            }
        }
    }

    // Model ready:
    function onModelReady()
    {
        var nItems = categoryListModel.count
        if (nItems === 1)
        {
            cellWidth = itemView.width
            cellHeight = itemView.height
        }
        else
        if (nItems === 2)
        {
            cellWidth = itemView.width/2
            cellHeight = itemView.height
        }
        else
        if (nItems === 3)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height
        }
        else
        if (nItems === 4)
        {
            cellWidth = itemView.width/2
            cellHeight = itemView.height/2
        }
        else
        if (nItems === 5)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/2
        }
        else
        if (nItems === 6)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/2
        }
        else
        if (nItems > 6)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/3
        }
    }
}
