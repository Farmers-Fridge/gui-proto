import QtQuick 2.5
import Common 1.0
import "../../.."

PageTemplate {
    id: presentationPage

    // Grid view current index:
    property int gridViewIndex: 0

    // Current add-on (TO DO):
    property variant currentAddOns: []
    signal selectedAddOnsChanged()
    onSelectedAddOnsChanged: console.log("SELECTED ADDONS = ", currentAddOns)

    // Footer right text:
    footerRightText: qsTr("Subtotal $") + _cartModel.cartSubTotal
    footerRightTextVisible: _cartModel.cartSubTotal > 0

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
        return "MENU_CHECKOUT_PAGE"
    }

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

    onTabClicked: {
        _controller.currentMenuItemForCategoryChanged();
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
                model: categoryModel.count

                Item {
                    anchors.fill: parent

                    // Current menu item by category:
                    property variant currentMenuItem

                    // Set current item for category:
                    onCurrentMenuItemChanged: {
                        _controller.setCurrentMenuItemForCategory(currentMenuItem)
                    }

                    // Category list model:
                    CategoryListModel {
                        id: categoryListModel
                        targetCategory: categoryModel.get(gridItemView.gridViewIndex).categoryName
                        Component.onCompleted: {
                            categoryListModel.modelReady.connect(gridItemView.onModelReady)
                            categoryListModel.modelReady.connect(pathItemView.onModelReady)
                        }
                    }

                    // Custom grid:
                    CustomGrid {
                        id: gridItemView
                        anchors.fill: parent
                        targetCategory: categoryListModel.targetCategory
                        opacity: ((_controller.currentCategory === categoryListModel.targetCategory) &&
                                  (_viewMode === "gridview")) ? 1 : 0
                        visible: opacity > 0
                        onGridImageClicked: {
                            mainApplication.loadPathView()
                            pathItemView.positionViewAtIndex(selectedIndex, PathView.Visible)
                        }
                        Component.onCompleted: {
                            _layoutMgr.currentLayoutChanged.connect(gridItemView.onModelReady)
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
            color: _colors.ffColor13
            border.color: _colors.ffColor7
            border.width: 1
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
                textColor: _colors.ffColor3
                label: qsTr("SEE NUTRITIONAL INFO")

                // Add current item to cart:
                onClicked: mainApplication.showNutritionalInfo()
            }

            // Current vend item name:
            LargeBoldItalicText {
                id: currentVendItemName
                anchors.top: nutritionalInfo.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                font.italic: true

                // Current menu item for category changed:
                function onCurrentMenuItemForCategoryChanged()
                {
                    var currentMenuItem = _controller.getCurrentMenuItemForCategory(_controller.currentCategory)
                    if (currentMenuItem)
                        currentVendItemName.text = currentMenuItem.vendItemName
                }

                Component.onCompleted: {
                    _controller.currentMenuItemForCategoryChanged.connect(onCurrentMenuItemForCategoryChanged)
                }
            }

            // Image place holder:
            Image {
                source: "qrc:/assets/ico-detailed_contents_placeholder.png"
                anchors.top: currentVendItemName.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Item {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    Image {
                        id: chickenImage
                        source: "qrc:/assets/ico-addseasoned-chicken-unselected.png"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        states: State {
                            name: "selected"
                            PropertyChanges {
                                target: chickenImage
                                source: "qrc:/assets/ico-addseasoned-chicken-selected.png"
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (chickenImage.state === "")
                                    chickenImage.state = "selected"
                                else
                                    chickenImage.state = ""
                            }
                        }
                    }
                    Image {
                        id: tofuImage
                        source: "qrc:/assets/ico-add-tofu-unselected.png"
                        anchors.right: parent.right
                        anchors.rightMargin: -32
                        anchors.verticalCenter: parent.verticalCenter
                        states: State {
                            name: "selected"
                            PropertyChanges {
                                target: tofuImage
                                source: "qrc:/assets/ico-add-tofu-selected.png"
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (tofuImage.state === "")
                                    tofuImage.state = "selected"
                                else
                                    tofuImage.state = ""
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        mainApplication.loadPathView.connect(onLoadPathView)
        mainApplication.loadGridView.connect(onLoadGridView)
        mainApplication.setMenuPageMode.connect(onSetMenuPageMode)
    }
}
