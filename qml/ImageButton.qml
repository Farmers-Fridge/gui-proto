import QtQuick 2.5

Image {
    id: imageButton
    fillMode: Image.PreserveAspectFit
    signal clicked()
    opacity: enabled ? 1 : .5

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

