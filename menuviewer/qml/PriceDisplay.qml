import QtQuick 2.5
import Common 1.0

Image {
    width: 128
    fillMode: Image.PreserveAspectFit
    rotation: 3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 8
    source: "qrc:/assets/ico-cardboard.png"
    antialiasing: true
    property string itemPrice: ""

    // Display price top right:
    StandardText {
        id: priceText
        anchors.centerIn: parent
        color: _colors.ffColor16
        text: itemPrice
    }
}
