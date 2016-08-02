import QtQuick 2.0
import Common 1.0
import "../.."

PageTemplate {
    id: presentationPage

    // Pig clicked:
    function onPigClicked()
    {
        _viewMode = "gridview"
    }

    // Cart clicked:
    function onCartClicked()
    {
        pageMgr.loadNextPage()
    }

    // Time out:
    function onIdleTimeOut()
    {
        pageMgr.loadFirstPage()
    }

    // Return next page id:
    function nextPageId()
    {
        return "CHECKOUT_PAGE"
    }

    // Grid view current index:
    property int gridViewIndex: 0

    // Load path view:
    function onLoadPathView()
    {
        _viewMode = "pathview"
    }

    // Load grid view:
    function onLoadGridView()
    {
        _viewMode = "gridview"
    }

    // Set menu page mode:
    function onSetMenuPageMode(mode)
    {
        _viewMode = mode
    }

    // Top contents:
    contents: Item {
        anchors.fill: parent

        // Top area:
        Item {
            id: topArea
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: bottomArea.visible ? bottomArea.top : parent.bottom

            // View repeater:
            Repeater {
                id: repeater
                anchors.fill: parent
                model: _categoryModel.count

                Item {
                    anchors.fill: parent

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
                        targetCategory: categoryListModel.targetCategory
                        interactive: false
                        opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                                  (_viewMode === "gridview")) ? 1 : 0
                        visible: opacity > 0
                        model: categoryListModel
                        onGridImageClicked: {
                            mainApplication.loadPathView()
                            pathItemView.positionViewAtIndex(selectedIndex, PathView.Visible)
                        }
                        Component.onCompleted: {
                            gridItemView.gridViewIndex = presentationPage.gridViewIndex
                            presentationPage.gridViewIndex++
                        }
                    }

                    // Path item view:
                    PathItemView {
                        id: pathItemView
                        targetCategory: categoryListModel.targetCategory
                        anchors.fill: parent
                        interactive: false
                        opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                                  (_viewMode === "pathview"))
                        visible: opacity > 0
                        model: categoryListModel
                    }
                }
            }
        }

        // Bottom area:
        Rectangle {
            id: bottomArea
            color: "transparent"
            border.color: "gray"
            anchors.bottom: parent.bottom
            width: parent.width
            height: Math.round((1/3)*parent.height)
            visible: _viewMode === "pathview"

            // See nutritional info:
            TextButton {
                id: nutritionalInfo
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8
                bold: true
                pixelSize: 24
                textColor: _settings.ffGreen
                label: qsTr("SEE NUTRITIONAL INFO")
            }

            // Add item to cart:
            ImageButton {
                id: addItem
                anchors.verticalCenter: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 112
                width: 96
                height: 96
                source: "qrc:/assets/ico-add.png"

                // Add current item to cart:
                onClicked: onAddCurrentItemToCart()
            }

            // Add to cart text:
            CommonText {
                anchors.top: addItem.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: addItem.horizontalCenter
                text: qsTr("ADD TO CART")
                font.pixelSize: 24
                color: _settings.ffGray
            }
        }
    }

    Component.onCompleted: {
        mainApplication.loadPathView.connect(onLoadPathView)
        mainApplication.loadGridView.connect(onLoadGridView)
        mainApplication.setMenuPageMode.connect(onSetMenuPageMode)
    }
}
