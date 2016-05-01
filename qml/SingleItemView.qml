import QtQuick 2.5
import QtQuick.Window 2.0

Item {
    id: singleItemView
    visible: vendItemName !== ""
    property alias menuImageUrl: flipableMenuImage.frontImage
    property alias nutritionFactImageUrl: flipableMenuImage.backImage
    onNutritionFactImageUrlChanged: console.log("************************************************************************************************************************", nutritionFactImageUrl)
    property alias itemPrice: priceDisplay.itemPrice

    Rectangle {
        id: container
        anchors.centerIn: parent
        color: _colors.ffTransparent
        border.color: _colors.ffDarkGreen
        width: parent.width*.75
        height: parent.height*.75

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: _colors.ffWhite
            anchors.centerIn: parent
            antialiasing: true
            width: Math.min(parent.width, parent.height)
            height: width
            visible: !flipableMenuImage.ready
            Rectangle {
                color: _colors.ffDarkGreen
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Flipable menu image:
        FlipableMenuImage {
            id: flipableMenuImage
            width: imageLoadingBkg.width
            height: imageLoadingBkg.height
            anchors.centerIn: parent
        }

        // Price:
        PriceDisplay {
            id: priceDisplay
        }
    }

    Item {
        anchors.top: container.bottom
        anchors.bottom: parent.bottom
        width: container.width
        anchors.horizontalCenter: container.horizontalCenter

        // Return to salads:
        ImageButton {
            id: returnToSaladsButton
            anchors.right: separator.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-return-to-salads.png"
            onClicked: mainApplication.loadGridView(index)
        }

        // Separator:
        Item {
            id: separator
            anchors.centerIn: parent
            width: 1
            height: parent.height
        }

        // Add to cart:
        ImageButton {
            id: addToCartButton
            source: "qrc:/qml/images/ico-add-to-cart.png"
            anchors.left: separator.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                _addToCartCommand.currentItem = categoryListModel.get(index)
                _addToCartCommand.execute()
            }
        }
    }
}
