import QtQuick 2.5
import QtQuick.Window 2.0
import Common 1.0

Item {
    id: singleItemView
    visible: vendItemName !== ""
    property alias menuImageUrl: flipableMenuImage.frontImage
    property alias nutritionFactImageUrl: flipableMenuImage.backImage
    property alias frontImageReady: flipableMenuImage.frontImageReady

    // Flip:
    function flip()
    {
        flipableMenuImage.flipped = !flipableMenuImage.flipped
    }

    Item {
        id: container
        anchors.fill: parent

        // Flipable menu image:
        FlipableMenuImage {
            id: flipableMenuImage
            width: imageLoadingBkg.width
            height: imageLoadingBkg.height
            anchors.centerIn: imageLoadingBkg

            // Add item to cart:
            ImageButton {
                id: addItem
                anchors.top: parent.top
                anchors.right: parent.right
                width: 96
                height: 96
                source: "qrc:/assets/ico-add.png"

                // Add current item to cart:
                onClicked: {
                    mainApplication.addCurrentItemToCart()
                }
            }
        }

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: _colors.ffColor16
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            width: Math.min(parent.width, parent.height)
            height: width
            visible: !flipableMenuImage.frontImageReady
            Rectangle {
                color: _colors.ffColor3
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }
    }
}
