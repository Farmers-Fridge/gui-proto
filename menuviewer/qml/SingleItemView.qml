import QtQuick 2.5
import QtQuick.Window 2.0
import Common 1.0

Item {
    id: singleItemView
    visible: vendItemName !== ""
    property alias menuImageUrl: flipableMenuImage.frontImage
    property alias nutritionFactImageUrl: flipableMenuImage.backImage
    property alias itemPrice: priceDisplay.itemPrice
    property alias frontImageReady: flipableMenuImage.frontImageReady

    // Flip:
    function flip()
    {
        flipableMenuImage.flipped = !flipableMenuImage.flipped
    }

    Item {
        id: container
        anchors.centerIn: parent
        anchors.fill: parent
        anchors.margins: 128

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: "white"
            anchors.centerIn: parent
            antialiasing: true
            width: Math.min(parent.width, parent.height)
            height: width
            visible: !flipableMenuImage.frontImageReady
            Rectangle {
                color: "darkgreen"
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
}
