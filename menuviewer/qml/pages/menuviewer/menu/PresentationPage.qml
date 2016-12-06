import QtQuick 2.5
import QtQuick.XmlListModel 2.0
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

    // Current menu item by category:
    property string _currentMenuItem: ""

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
        if (_cartModel.cartCount > 0)
            _pageMgr.loadNextPage()
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

    // XML version model:
    CustomXmlListModel {
        id: categoryModel
        source: getCategoryModelSource()
        query: _appData.query.categoryQuery

        XmlRole { name: "categoryName"; query: "categoryName/string()"; isKey: true }
        XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
        XmlRole { name: "header"; query: "header/string()"; isKey: true }

        onStatusChanged: {
            _appIsBusy = (status === XmlListModel.Loading)

            // Load main application:
            if (status !== XmlListModel.Loading)
            {
                // Error:
                if (status === XmlListModel.Error)
                {
                    // Log:
                    console.log("Can't load: " + source)
                }
                else
                // Model ready:
                if (status === XmlListModel.Ready)
                {
                    // Set current category name:
                    _controller.currentCategory = categoryModel.get(0).categoryName

                    // Load first view:
                    viewLoader.sourceComponent = viewComponent

                    // Log:
                    console.log(source + " loaded successfully")
                }
            }
        }
    }

    // Tab clicked:
    onTabClicked: {
        viewLoader.sourceComponent = undefined
        _controller.currentCategory = categoryName
        viewLoader.sourceComponent = viewComponent
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

            // View component:
            ViewComponent {
                id: viewComponent
            }

            // Loader:
            Loader {
                id: viewLoader
                anchors.fill: parent
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
                text: _currentMenuItem
            }

            // Image place holder:
            Image {
                source: "qrc:/assets/ico-detailed_contents_placeholder.png"
                anchors.top: currentVendItemName.bottom
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                asynchronous: true

                Item {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    Image {
                        id: chickenImage
                        source: "qrc:/assets/ico-addseasoned-chicken-unselected.png"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        asynchronous: true
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
                        asynchronous: true
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

