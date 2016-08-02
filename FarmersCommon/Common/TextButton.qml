import QtQuick 2.5

Item {
    id: textButton
    signal clicked()
    implicitWidth: label.width+16
    implicitHeight: label.height+16
    opacity: enabled ? 1 : .5
    property alias label: label.text
	property alias textColor: label.color
    property alias pixelSize: label.font.pixelSize
    property alias bold: label.font.bold
	
	CommonText {
		id: label
		anchors.centerIn: parent
	}
	
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: textButton.clicked()
    }
    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: textButton
            scale: .97
        }
    }
}

