import QtQuick 2.5

Item {
    id: container
    property int size: 128
    width: size
    height: size
    property int imageOffset: 0
    property alias source: image.source
    signal clicked()

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: container.clicked()
    }

    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: container
            scale: .95
        }
    }
}
