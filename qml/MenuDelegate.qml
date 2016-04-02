import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.1

Component {
    id: menuDelegate
    Package {
        // Category list model private:
        CategoryListModel {
            id: categoryListModel
            targetCategory: categoryName
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
                    PropertyChanges { target: photosShade; opacity: 0 }
                },
                // Full screen:
                State {
                    name: "fullscreen"
                    PropertyChanges { target: photosShade; opacity: 1 }
                }
            ]
        }

        // Full screen:
        Item {
            Package.name: "fullscreen"
            PathView {
                id: photosListView
                pathItemCount: 2
                model: visualModel.parts.list
                anchors.fill: parent
                highlightRangeMode: PathView.StrictlyEnforceRange
                snapMode: ListView.SnapOneItem
                interactive: false

                // Path:
                path: Path {
                    startX: -width/2; startY: height/2
                    PathLine {x: width + width/2; y:height/2 }
                }

                // Animation:
                NumberAnimation {id: anim; target: photosListView; property: "contentX"; duration: 500; easing.type: Easing.OutBounce}

                // Go to specific index:
                function gotoIndex(idx) {
                    photosListView.currentIndex = idx
                }

                // Navigate left:
                function onNavigateLeft()
                {
                    var incr = 1
                    var currentIndex = photosListView.currentIndex
                    currentIndex -= incr
                    photosListView.gotoIndex(currentIndex)
                }

                // Navigate right:
                function onNavigateRight()
                {
                    var incr = 1
                    var currentIndex = photosListView.currentIndex
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
