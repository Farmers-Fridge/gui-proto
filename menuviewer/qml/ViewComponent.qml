import QtQuick 2.5

Component {
    Rectangle {
        id: root
        anchors.fill: parent

        // Model ready:
        function onModelReady()
        {
            gridItemView.targetCategory = _controller.currentCategory
            pathItemView.targetCategory = _controller.currentCategory
            gridItemView.updateLayout()
        }

        // Category list model:
        CategoryListModel {
            id: categoryListModel
            targetCategory: _controller.currentCategory
            Component.onCompleted: {
                categoryListModel.modelReady.connect(root.onModelReady)
            }
        }

        // Custom grid:
        CustomGrid {
            id: gridItemView
            anchors.fill: parent
            opacity: _viewMode == "gridview" ? 1 : 0
            visible: opacity > 0
            onGridImageClicked: {
                mainApplication.loadPathView()
                pathItemView.positionViewAtIndex(selectedIndex, PathView.Visible)
            }
            Component.onCompleted: {
                _layoutMgr.currentLayoutChanged.connect(gridItemView.updateLayout)
                gridItemView.gridViewIndex = presentationPage.gridViewIndex
                presentationPage.gridViewIndex++
            }
            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }

        // Path item view:
        PathItemView {
            id: pathItemView
            anchors.fill: parent
            interactive: false
            opacity: _viewMode === "pathview" ? 1 : 0
            visible: opacity > 0
            model: categoryListModel
            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }
    }
}
