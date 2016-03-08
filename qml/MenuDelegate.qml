import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.1

Component {
    id: menuDelegate
    Package {
        // Category list model private:
        CategoryListModel {
            id: categoryListModelPrivate
            targetCategory: categoryName
            onModelReady: categoryListModel.initialize()
        }

        // Category list model:
        ListModel {
            id: categoryListModel
            signal modelReady()
            function initialize()
            {
                var nItems = categoryListModelPrivate.count
                if ((nItems %2 !== 0) && (nItems !== 1))
                {
                    // Insert empty item:
                    for (var i=0; i<categoryListModelPrivate.count*2; i++)
                    {
                        // Get model item:
                        var modelItem = categoryListModelPrivate.get(i/2)

                        // Get data:
                        var data = {
                            vendItemName: "",
                            icon: "",
                            nutrition: "",
                            category: "",
                            price: "",
                        }

                        if (i%2 === 0)
                        {
                            var data = {
                                vendItemName: modelItem.vendItemName,
                                icon: modelItem.icon,
                                nutrition: modelItem.nutrition,
                                category: modelItem.category,
                                price: modelItem.price
                            }
                        }
                        categoryListModel.append(data)
                    }
                }
                else
                {
                    // Insert empty item:
                    for (var i=0; i<categoryListModelPrivate.count; i++)
                    {
                        // Get model item:
                        var modelItem = categoryListModelPrivate.get(i)

                        // Get data:
                        var data = {
                            vendItemName: modelItem.vendItemName,
                            icon: modelItem.icon,
                            nutrition: modelItem.nutrition,
                            category: modelItem.category,
                            price: modelItem.price
                        }
                        categoryListModel.append(data)
                    }
                }

                // Notify:
                categoryListModel.modelReady()
            }
        }

        // Delegate model:
        DelegateModel {
            id: visualModel; delegate: MenuPictureDelegate { }
            model: categoryListModel
        }

        // Menu wrapper:
        MenuWrapper {
            id: menuWrapper
            model: visualModel.parts.grid

            // States:
            states: [
                // In grid:
                State {
                    name: "inGrid"
                    PropertyChanges { target: photosListView; interactive: false }
                    PropertyChanges { target: photosShade; opacity: 0 }
                },
                // Full screen:
                State {
                    name: "fullscreen"
                    PropertyChanges { target: photosListView; interactive: true }
                    PropertyChanges { target: photosShade; opacity: 1 }
                    PropertyChanges { target: backButton; onClicked: menuWrapper.state = "inGrid" }
                }
            ]
        }

        // Full screen:
        Item {
            Package.name: "fullscreen"
            ListView {
                id: photosListView; model: visualModel.parts.list; orientation: Qt.Horizontal
                width: mainWindow.width; height: mainWindow.height; interactive: false
                highlightRangeMode: ListView.StrictlyEnforceRange; snapMode: ListView.SnapOneItem
                enabled: false

                // Animation:
                NumberAnimation {id: anim; target: photosListView; property: "contentX"; duration: 500; easing.type: Easing.OutBounce}

                // Go to specific index:
                function gotoIndex(idx) {
                    anim.running = false
                    var pos = photosListView.contentX
                    photosListView.positionViewAtIndex(idx, ListView.Beginning)
                    var destPos = photosListView.contentX
                    anim.from = pos
                    anim.to = destPos
                    anim.running = true
                }

                // Navigate left:
                function onNavigateLeft()
                {
                    console.log(categoryListModelPrivate.count)
                    var incr = ((categoryListModelPrivate.count%2) === 0 ? 1 : 2)
                    var currentIndex = photosListView.currentIndex
                    if ((currentIndex-incr) >=0)
                        currentIndex -= incr
                    photosListView.gotoIndex(currentIndex)
                }

                // Navigate right:
                function onNavigateRight()
                {
                    var incr = ((categoryListModelPrivate.count%2) === 0 ? 1 : 2)
                    var currentIndex = photosListView.currentIndex
                    if (currentIndex < (photosListView.count-incr))
                        currentIndex += incr
                    photosListView.gotoIndex(currentIndex)
                }

                // Add current item:
                function onAddCurrentItem()
                {
                    var currentItem = categoryListModel.get(photosListView.currentIndex)
                    if ((typeof(currentItem) !== "undefined") && (_controller.currentCategory === categoryName))
                    {
                        _addToCartCommand.currentItem = currentItem
                        _addToCartCommand.execute()
                    }
                }

                // Handle navigation:
                Component.onCompleted: {
                    mainApplication.navigateLeft.connect(onNavigateLeft)
                    mainApplication.navigateRight.connect(onNavigateRight)
                    mainApplication.addCurrentItem.connect(onAddCurrentItem)
                }
            }
        }
    }
}
