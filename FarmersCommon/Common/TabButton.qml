import QtQuick 2.5

Item {
    id: textButton
    signal clicked()
    property alias color: innerRect.color
    property bool selected: false
	property alias backgroundImage: image.source
	property alias text: label.text

    Rectangle {
        id: innerRect
		anchors.fill: parent

        Image {
            id: image
            anchors.fill: parent
            fillMode: Image.Stretch
            visible: selected
        }

		CommonText {
			id: label
			anchors.centerIn: parent
			color: selected ? "white" : "#858687"
			text: categoryName
		}
	}				
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: textButton.clicked()
    }
}

