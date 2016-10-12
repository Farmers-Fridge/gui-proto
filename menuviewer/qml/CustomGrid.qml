import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0

Rectangle {
    id: customGrid
    property string targetCategory: ""
    property int gridViewIndex: 0
    property variant layout: []
    signal gridImageClicked(int selectedIndex)
    anchors.fill: parent

    // Model changed:
    function onModelReady()
    {
        var nImages = categoryListModel.count
        if (nImages > 0) {
            layout = _layoutMgr.getLayoutFilledCells(nImages-1)
            gridLoader.sourceComponent = undefined
            gridLoader.sourceComponent = gridComponent
        }
    }

    // Return layout index:
    function layoutIndex(index)
    {
        return layout.indexOf(index)
    }

    // Get price:
    function getPrice(index)
    {
        if (layoutIndex(index) >= 0)
        {
            return categoryListModel.get(layoutIndex(index)).price
        }
        return ""
    }

    // Get vendItemName:
    function getVendItemName(index)
    {
        if (layoutIndex(index) >= 0)
        {
            return categoryListModel.get(layoutIndex(index)).vendItemName
        }
        return ""
    }

    Component {
        id: gridComponent
        Item {
            id: itemView
            anchors.fill: parent
            property int currentIndex: 0

            // Add current item to cart:
            function onAddCurrentItemToCart()
            {
                // Run add to cart command:
                _addToCartCommand.currentItem = categoryListModel.get(itemView.currentIndex)
                _addToCartCommand.execute()
            }

            Repeater {
                model: _layoutMgr.nLayouts
                Rectangle {
                    width: customGrid.width/3
                    height: customGrid.height/3
                    x: (index%3)*customGrid.width/3
                    y: Math.floor(index/3)*customGrid.height/3
                    color: "white"

                    Item {
                        anchors.fill: parent
                        anchors.margins: 3

                        Image {
                            id: originalImage
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            source: (layoutIndex(index) >= 0) ?
                                getImageSource(targetCategory, categoryListModel.get(layoutIndex(index)).icon, false) : ""
                            Item {
                                width: originalImage.paintedWidth
                                height: originalImage.paintedHeight
                                anchors.centerIn: originalImage

                                // Handle clicks:
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        // Set current item:
                                        currentMenuItem = categoryListModel.get(layoutIndex(index))
                                        gridImageClicked(layoutIndex(index)-1)
                                    }
                                }

                                // Add item to cart:
                                ImageButton {
                                    id: addItem
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    width: 48
                                    height: 48
                                    source: "qrc:/assets/ico-add.png"
                                    z: 1e9
                                    onClicked: {
                                        itemView.currentIndex = layoutIndex(index)
                                        itemView.onAddCurrentItemToCart()
                                    }
                                    visible: originalImage.status === Image.Ready
                                }
                            }
                        }
                    }

                    // Footer:
                    Item {
                        id: footer
                        visible: false
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 0.33*parent.height

                        // Vend item name:
                        StandardText {
                            id: ventItemNameText
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width*85/100
                            wrapMode: Text.WordWrap
                            text: getVendItemName(index)
                            font.italic: true
                            color: _colors.ffColor8
                        }

                        // Item price:
                        StandardText {
                            id: priceText
                            anchors.top: ventItemNameText.bottom
                            anchors.bottomMargin: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: getPrice(index)
                            color: _colors.ffColor9
                        }
                    }
                }
            }
        }
    }

    // Grid loader:
    Loader {
        id: gridLoader
        anchors.fill: parent
    }
}
