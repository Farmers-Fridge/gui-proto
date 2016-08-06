import QtQuick 2.5
import Common 1.0

Item {
    id: textButton
    signal clicked()
    property alias color: innerRect.color
    property bool selected: false
	property alias backgroundImage: image.source
	property alias text: label.text

    // Background:
    Rectangle {
        id: innerRect
        anchors.fill: parent
	}				

    // Dish image:
    Image {
        id: image
        width: parent.width
        anchors.bottom: innerRect.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        visible: selected
    }

    // Dish label:
    LargeBoldText {
        id: label
        anchors.centerIn: parent
        color: selected ? "white" : _settings.ffDarkGray
        text: categoryName
    }

    // Handle click:
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: textButton.clicked()
    }
}

