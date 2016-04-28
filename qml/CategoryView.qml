import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "script/Utils.js" as Utils

// Category view:
Item {
    width: parent.width
    height: _generalSettings.toolbarHeight

    // Background:
    Image {
        anchors.fill: parent
        source: "qrc:/qml/images/ico-top-bg.png"
        smooth: true
    }

    // Dishes images:
    property variant dishImages: [
        {
            name: "Salads",
            selected: "qrc:/qml/images/ico-salads-dr.png",
            unselected: "qrc:/qml/images/ico-salads-lg.png"
        },
        {
            name: "Proteins",
            selected: "qrc:/qml/images/ico-dishes-dr.png",
            unselected: "qrc:/qml/images/ico-dishes-lg.png"
        },
        {
            name: "Snacks",
            selected: "qrc:/qml/images/ico-snacks-dr.png",
            unselected: "qrc:/qml/images/ico-snacks-lg.png"
        },
        {
            name: "Drinks",
            selected: "qrc:/qml/images/ico-drinks-dr.png",
            unselected: "qrc:/qml/images/ico-drinks-lg.png"
        }
    ]

    // Filter images:
    property variant filterImages: [
        {
            name: "Vegan",
            selected: "qrc:/qml/images/ico-vegan-checked.png",
            unselected: "qrc:/qml/images/ico-vegan-unchecked.png"
        },
        {
            name: "GlutenFree",
            selected: "qrc:/qml/images/ico-gluten-free-checked.png",
            unselected: "qrc:/qml/images/ico-gluten-free-unchecked.png"
        },
        {
            name: "HighProtein",
            selected: "qrc:/qml/images/ico-high-prot-checked.png",
            unselected: "qrc:/qml/images/ico-high-prot-unchecked.png"
        },
        {
            name: "LiteBites",
            selected: "qrc:/qml/images/ico-lite-bites-checked.png",
            unselected: "qrc:/qml/images/ico-lite-bites-unchecked.png"
        }
    ]

    // Get checked image:
    function getSelectedImage(categoryName)
    {
        var target = categoryName.toUpperCase()
        for (var i=0; i<dishImages.length; i++)
        {
            var current = dishImages[i].name.toUpperCase()
            if (current === target)
                return dishImages[i].selected
        }
        return ""
    }

    // Get unchecked image:
    function getUnSelectedImage(categoryName)
    {
        var target = categoryName.toUpperCase()
        for (var i=0; i<dishImages.length; i++)
        {
            var current = dishImages[i].name.toUpperCase()
            if (current === target)
                return dishImages[i].unselected
        }
        return ""
    }

    // Top area:
    Item {
        id: topArea
        width: parent.width
        height: parent.height/2
        anchors.top: parent.top

        // Styled title:
        Image {
            id: styledTitle
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/qml/images/ico-select-category.png"
        }

        Row {
            anchors.fill: parent
            Repeater {
                model: _categoryModel
                Item {
                    width: topArea.width/_categoryModel.count
                    height: topArea.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 4

                    // Toggle image button:
                    ToggleImageButton {
                        id: checkableImage
                        selectedImage: getSelectedImage(categoryName)
                        unSelectedImage: getUnSelectedImage(categoryName)
                        anchors.centerIn: parent
                        selected: _controller.currentCategory === categoryName
                        onClicked: _controller.currentCategory = categoryName
                    }
                }
            }
        }

    }

    // Central line:
    Line {
        id: centralLine
        width: styledTitle.width
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topArea.bottom
    }

    Row {
        id: row
        width: parent.width
        height: parent.height/2
        anchors.top: centralLine.bottom

        Repeater {
            id: repeater
            model: filterImages

            Item {
                width: parent.width/filterImages.length
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                // Toggle image button:
                ToggleImageButton {
                    id: checkableFilter
                    selectedImage: filterImages[index].selected
                    unSelectedImage: filterImages[index].unselected
                    anchors.centerIn: parent
                    selected: _controller.currentFilter === filterImages[index].name
                    onClicked: _controller.currentFilter = filterImages[index].name
                    Image {
                        anchors.left: parent.left
                        anchors.leftMargin: -4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -8
                        source: "qrc:/qml/images/ico-checkmark.png"
                        visible: checkableFilter.selected
                    }
                }
            }
        }
    }
}
