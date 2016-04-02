import QtQuick 2.5

Rectangle {
    id: container
    width: 128
    height: width
    color: "#736F63"
    radius: width
    property int imageOffset: 0
    property alias source: image.source
    signal clicked()

    Image {
        id: image
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: imageOffset
        fillMode: Image.PreserveAspectFit
        width: parent.width-36
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
