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
        }

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: _settings.ffWhite
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            width: Math.min(parent.width, parent.height)
            height: width
            visible: !flipableMenuImage.frontImageReady
            Rectangle {
                color: _settings.ffGreen
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }
    }
}
