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
        Item {
            id: menuWrapper
            Package.name: "browser"
            state: "inGrid"
            onStateChanged: _viewState = state
            GridView {
                id: photosGridView
                model: visualModel.parts.grid
                width: mainWindow.width; height: mainWindow.height - 21
                x: 0; y: 21;
                cellWidth: _settings.gridImageWidth; cellHeight: _settings.gridImageHeight
                interactive: false
                onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
                visible: _controller.currentCategory === categoryName
            }
            MouseArea {
                anchors.fill: parent
                onClicked: menuWrapper.state = "fullscreen"
            }
            states: [
            State {
                name: "inGrid"
                PropertyChanges { target: photosGridView; interactive: true }
             },
            State {
                name: "fullscreen"
                PropertyChanges { target: photosGridView; interactive: false }
                PropertyChanges { target: photosListView; interactive: true }
                PropertyChanges { target: photosShade; opacity: 1 }
                PropertyChanges { target: backButton; onClicked: menuWrapper.state = "inGrid" }
            }
            ]
            function onGoBackToMainPage()
            {
                menuWrapper.state = "inGrid"
            }
            Component.onCompleted: mainApplication.goBackToMainPage.connect(onGoBackToMainPage)
        }

        // Full screen:
        Item {
            Package.name: "fullscreen"
            ListView {
                id: photosListView; model: visualModel.parts.list; orientation: Qt.Horizontal
                width: mainWindow.width; height: mainWindow.height; interactive: false
                onCurrentIndexChanged: photosGridView.positionViewAtIndex(currentIndex, GridView.Contain)
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
