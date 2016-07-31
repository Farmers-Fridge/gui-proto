import QtQuick 2.5
import Common 1.0

Row {
    id: row
    width: parent.width
    height: parent.height

    // Filter images:
    property variant filterImages: [
        {
            name: "Vegan",
            selected: "qrc:/assets/ico-vegan-checked.png",
            unselected: "qrc:/assets/ico-vegan-unchecked.png"
        },
        {
            name: "GlutenFree",
            selected: "qrc:/assets/ico-gluten-free-checked.png",
            unselected: "qrc:/assets/ico-gluten-free-unchecked.png"
        },
        {
            name: "HighProtein",
            selected: "qrc:/assets/ico-high-prot-checked.png",
            unselected: "qrc:/assets/ico-high-prot-unchecked.png"
        },
        {
            name: "LiteBites",
            selected: "qrc:/assets/ico-lite-bites-checked.png",
            unselected: "qrc:/assets/ico-lite-bites-unchecked.png"
        }
    ]

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
                    source: "qrc:/assets/ico-checkmark.png"
                    visible: checkableFilter.selected
                }
            }
        }
    }
}
