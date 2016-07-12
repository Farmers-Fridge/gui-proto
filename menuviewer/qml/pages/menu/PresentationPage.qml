import QtQuick 2.0
import Common 1.0
import "../.."

MenuPageTemplate {
    id: presentationPage
    homeVisible: true
    pigVisible: viewMode === "pathview"
    cartVisible: true

    // Pig clicked:
    function onPigClicked()
    {
        viewMode = "gridview"
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

    // Current view mode:
    property string viewMode: "gridview"

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

    // Top contents:
    topContents: Item {
        anchors.fill: parent
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
                              (viewMode === "gridview")) ? 1 : 0
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
                    width: parent.width
                    height: parent.height
                    interactive: false
                    opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                              (viewMode === "pathview"))
                    visible: opacity > 0
                    model: categoryListModel
                }
            }
        }
    }

    // Bottom contents:
    bottomContents: Item {
        anchors.fill: parent

        // Add item to cart:
        ImageButton {
            id: addItem
            anchors.verticalCenter: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 60
            width: 96
            height: 96
            source: "qrc:/assets/ico-add.png"
            onClicked: mainApplication.addCurrentItemToCart()
            visible: viewMode === "pathview"
        }

        // Add to cart:
        CommonText {
            anchors.top: addItem.bottom
            anchors.horizontalCenter: addItem.horizontalCenter
            font.bold: true
            text: qsTr("ADD TO CART")
            visible: viewMode === "pathview"
        }

        // Sweet treats display:
        Item {
            anchors.fill: parent
            visible: viewMode === "gridview"
            CommonText {
                anchors.centerIn: parent
                text: qsTr("SWEET TREATS (TO DO)")
                color: _settings.ffGreen
            }
        }

        // Nutrional info:
        Item {
            anchors.fill: parent
            visible: viewMode === "pathview"
            TextButton {
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("SEE NUTRITIONAL INFO")
                textColor: _settings.ffGreen
                border.color: _settings.ffGreen
                onClicked: mainApplication.showNutritionalInfo()
            }

            // Text:
            CommonText {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                color: _settings.ffGreen
                text: "PROVIDE DETAILED ITEM DESCRIPTION HERE"
            }
        }
    }

    Component.onCompleted: {
        mainApplication.loadPathView.connect(onLoadPathView)
        mainApplication.loadGridView.connect(onLoadGridView)
        mainApplication.setMenuPageMode.connect(onSetMenuPageMode)
    }
}
