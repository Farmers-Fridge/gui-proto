import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import "../script/Utils.js" as Utils
import ".."

Page {
    id: firstPage
    pageId: "_menupage_"
    idleTime: _settings.pageIdleTime
    property int gridViewIndex: 0
    property string viewMode: "gridview"

    // Time out:
    function onIdleTimeOut()
    {
        mainApplication.loadPage("_idlepage_")
    }

    // Load path view:
    function onLoadPathView()
    {
        viewMode = "pathview"
    }

    // Load grid view:
    function onLoadGridView()
    {
        viewMode = "gridview"
    }

    // Set menu page mode:
    function onSetMenuPageMode(mode)
    {
        viewMode = mode
    }

    // Primary header area:
    PrimaryHeaderArea {
        id: categoryView
        anchors.top: parent.top
        width: parent.width
        height: _settings.toolbarHeight
    }

    // Background:
    Rectangle {
        color: "black"
        width: parent.width
        anchors.top: categoryView.bottom
        anchors.bottom: primaryBottomArea.top
    }

    Repeater {
        id: repeater

        // Model ready:
        function onModelReady()
        {
            repeater.model = categoryModel.count
        }

        Item {
            width: parent.width
            anchors.top: categoryView.bottom
            anchors.bottom: primaryBottomArea.top

            // Category list model:
            CategoryListModel {
                id: categoryListModel
                targetCategory: _categoryModel.get(gridItemView.gridViewIndex).categoryName
                Component.onCompleted: categoryListModel.modelReady.connect(gridItemView.onModelReady)
            }

            // Grid item view:
            GridItemView {
                id: gridItemView
                anchors.fill: parent
                interactive: false
                property int gridViewIndex: 0
                opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                    (viewMode === "gridview")) ? 1 : 0
                visible: opacity > 0
                model: categoryListModel
                Behavior on opacity {
                    NumberAnimation {duration: _settings.pageTransitionDelay}
                }
                onGridImageClicked: {
                    mainApplication.loadPathView()
                    pathItemView.positionViewAtIndex(selectedIndex, PathView.Visible)
                }
                Component.onCompleted: {
                    gridItemView.gridViewIndex = firstPage.gridViewIndex
                    firstPage.gridViewIndex++
                }
            }

            // Path item view:
            PathItemView {
                id: pathItemView
                anchors.fill: parent
                interactive: false
                opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                    (viewMode === "pathview") && (categoryListModel.count > 1))
                visible: opacity > 0
                model: categoryListModel
                Behavior on opacity {
                    NumberAnimation {duration: _settings.pageTransitionDelay}
                }
            }

            // Single item view:
            SingleItemView {
                id: singleItemView
                anchors.fill: parent
                opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                    (viewMode === "pathview") && (categoryListModel.count < 2)) ? 1 : 0
                visible: opacity > 0
                Behavior on opacity {
                    NumberAnimation {duration: _settings.pageTransitionDelay}
                }
            }
        }

        Component.onCompleted: mainApplication.modelReady.connect(onModelReady)
    }

    // Bottom area:
    BottomArea {
        id: primaryBottomArea
        width: parent.width
        height: _settings.toolbarHeight
        anchors.bottom: parent.bottom
    }

    Component.onCompleted: {
        mainApplication.loadPathView.connect(onLoadPathView)
        mainApplication.loadGridView.connect(onLoadGridView)
        mainApplication.setMenuPageMode.connect(onSetMenuPageMode)
    }
}

