import QtQuick 2.5

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
    CommonText {
        id: label
        anchors.centerIn: parent
        color: selected ? "white" : "#858687"
        text: categoryName
    }

    // Handle click:
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: textButton.clicked()
    }
}

