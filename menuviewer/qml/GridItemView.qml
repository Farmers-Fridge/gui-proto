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
            anchors.fill: parent
            visible: originalImage.status !== Image.Ready
            Rectangle {
                color: "darkgreen"
                antialiasing: true
                anchors { fill: parent; margins: 3 }

                // Busy indicator:
                BusyIndicator {
                    id: busyIndicator
                    anchors.centerIn: parent
                    on: originalImage.status === Image.Loading
                    visible: on
                }
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
                source = "file:///" + _controller.offLinePath + "/" + targetCategory + "/Square Thumbnails/" + icon
            }
            else
            // In line:
            {
                source = Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
            }

            return source
        }

        // Original image:
        Item {
            anchors.fill: parent

            // Image area:
            Item {
                id: imageArea
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: footer.top

                // Original image:
                Image {
                    id: originalImage
                    antialiasing: true
                    asynchronous: true
                    source: imageDelegate.getImageSource()
                    cache: true
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent

                    Item {
                        width: originalImage.paintedWidth
                        height: originalImage.paintedHeight
                        anchors.centerIn: originalImage

                        // Handle clicks:
                        MouseArea {
                            anchors.fill: parent
                            onClicked: gridImageClicked(index-1)
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
                            onClicked: {
                                currentIndex = index
                                onAddCurrentItemToCart()
                            }
                            visible: originalImage.status === Image.Ready
                        }
                    }
                }
            }

            // Footer:
            Item {
                id: footer
                anchors.bottom: parent.bottom
                width: parent.width
                height: 0.2*parent.height

                // Vend item name:
                CommonText {
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: vendItemName
                    font.italic: true
                    font.pixelSize: 24
                    color: "#55575B"
                }

                // Item price:
                CommonText {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: price
                    font.pixelSize: 22
                    color: "gray"
                }
            }
        }
    }

    // Model ready:
    function onModelReady()
    {
        var nItems = categoryListModel.count
        cellHeight = itemView.height/3
        if (nItems === 1)
        {
            cellWidth = itemView.width
        }
        else
        if ((nItems === 2) || (nItems === 4))
        {
            cellWidth = itemView.width/2
        }
        else
        if ((nItems === 3) || (nItems >= 5))
        {
            cellWidth = itemView.width/3
        }
    }

    // Add current item to cart:
    function onAddCurrentItemToCart()
    {
        // Run add to cart command:
        _addToCartCommand.currentItem = model.get(itemView.currentIndex)
        console.log(_addToCartCommand.currentItem.category)
        _addToCartCommand.execute()
    }
}
