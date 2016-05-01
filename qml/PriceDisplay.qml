import QtQuick 2.5

Image {
    width: 128
    fillMode: Image.PreserveAspectFit
    rotation: 3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 8
    source: "qrc:/qml/images/ico-cardboard.png"
    antialiasing: true
    property string itemPrice: ""

    // Display price top right:
    CommonText {
        id: priceText
        anchors.centerIn: parent
        color: _colors.ffWhite
        text: itemPrice
    }
}
