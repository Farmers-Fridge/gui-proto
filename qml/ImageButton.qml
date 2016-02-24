import QtQuick 2.4

Image {
    id: imageButton
    fillMode: Image.PreserveAspectFit
    signal clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: imageButton.clicked()
    }
    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: imageButton
            scale: .95
        }
    }
}

