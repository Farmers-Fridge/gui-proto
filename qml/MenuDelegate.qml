import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.1

Component {
    id: menuDelegate
    Package {
        // Delegate model:
        DelegateModel {
            id: visualModel; delegate: MenuPictureDelegate { }
            model: CategoryListModel { id: categoryListModel; targetCategory: categoryName }
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
                    var currentIndex = photosListView.currentIndex
                    if (currentIndex > 0)
                        currentIndex--
                    photosListView.gotoIndex(currentIndex)
                }

                // Navigate right:
                function onNavigateRight()
                {
                    var currentIndex = photosListView.currentIndex
                    if (currentIndex < (photosListView.count-1))
                        currentIndex++
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
