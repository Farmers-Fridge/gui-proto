import QtQuick 2.4

PathView {
    id: view

    // Number of loaded images:
    property int nLoadedImages: 0

    // Current item index:
    property int currentItemIndex: -1

    // Carousel ready?
    signal carouselReady()

    /*
    // Delegate:
    delegate: Rectangle {
        id: container
        color: "transparent"
        property bool isCurrentItem: index === currentItemIndex
        border.color: isCurrentItem ? "orange" : "transparent"
        border.width: 5

        width: _settings.menuItemWidth
        height: _settings.menuItemHeight

        // Plate:
        Plate {
            id: plate
            anchors.fill: parent
            frontImage: Utils.urlPublicStatic(icon)
            backImage: nutrition !== "" ? Utils.urlPublicStatic(nutrition) : ""
            xAxis: 1
            yAxis: 0
            backAngle: 180

            // Show nutrition facts:
            function onShowNutritionFacts()
            {
                if (isCurrentItem && (nutrition !== ""))
                    plate.state = "back"
            }

            Component.onCompleted: {
                _nutritionCommand.showNutritionFacts.connect(onShowNutritionFacts)
            }
        }

        // Handle clicks:
        MouseArea {
            anchors.fill: parent
            enabled: plate.state === ""
            onClicked: currentItemIndex = index
        }

        // Z-order matters!
        ImageButton {
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4
            source: "qrc:/icons/ico-add_to_cart.png"
            width: 48
            visible: (isCurrentItem && (plate.state === ""))
            onClicked: {
                _addToCartCommand.currentItem = categoryListModel.get(currentItemIndex)
                _addToCartCommand.execute()
            }
        }

        // Z-order matters!
        ImageButton {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4
            source: "qrc:/icons/ico-question_green.png"
            width: 48
            visible: (isCurrentItem && (plate.state === "") && (nutrition !== ""))
            onClicked: plate.state = "back"
        }
    }*/

    // Path:
    path: Ellipse {
        width: view.width
        height: view.height
        //margin: _settings.menuItemWidth/2
    }
}
