import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtQml.Models 2.1

Component {
    id: albumDelegate
    Package {

        Item {
            Package.name: 'browser'
            GridView {
                id: photosGridView; model: visualModel.parts.grid; width: mainWindow.width; height: mainWindow.height - 21
                x: 0; y: 21; cellWidth: 160; cellHeight: 153; interactive: false
                onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
            }
        }

        Item {
            Package.name: 'fullscreen'
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

                Component.onCompleted: {
                    mainApplication.navigateLeft.connect(onNavigateLeft)
                    mainApplication.navigateRight.connect(onNavigateRight)
                }
            }
        }

        Item {
            Package.name: 'album'
            id: albumWrapper; width: 210; height: 220
            onStateChanged: mainApplication.viewState = state

            DelegateModel {
                id: visualModel; delegate: MenuPictureDelegate { }
                model: CategoryListModel { id: categoryListModel; targetCategory: categoryName }
            }

            BusyIndicator {
                id: busyIndicator
                anchors { centerIn: parent; verticalCenterOffset: -20 }
                on: categoryListModel.status != XmlListModel.Ready
            }

            PathView {
                id: photosPathView; model: visualModel.parts.stack; pathItemCount: 5
                visible: !busyIndicator.visible
                anchors.centerIn: parent; anchors.verticalCenterOffset: -30
                path: Path {
                    PathAttribute { name: 'z'; value: 9999.0 }
                    PathLine { x: 1; y: 1 }
                    PathAttribute { name: 'z'; value: 0.0 }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: albumWrapper.state = "inGrid"
            }

            // TO DO: no need for flipable
            Tag {
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 10 }
                frontLabel: categoryName
            }

            states: [
            State {
                name: "inGrid"
                PropertyChanges { target: photosGridView; interactive: true }
                PropertyChanges { target: albumsShade; opacity: 1 }
                PropertyChanges { target: backButton; onClicked: albumWrapper.state = "" }
            },
            State {
                name: 'fullscreen'
                PropertyChanges { target: photosGridView; interactive: false }
                PropertyChanges { target: photosListView; interactive: true }
                PropertyChanges { target: photosShade; opacity: 1 }
                PropertyChanges { target: backButton; onClicked: albumWrapper.state = "inGrid" }
            }
            ]
        }
    }
}
