import QtQuick 2.5

Image {
    id: imageButton
    property string selectedImage: ""
    property string unSelectedImage: ""
    property bool selected: false
    source: selected ? selectedImage : unSelectedImage
    fillMode: Image.PreserveAspectFit
    signal clicked()
    opacity: enabled ? 1 : .5
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: imageButton.clicked()
    }
    states: State {
        name: "selected"
        when: mouseArea.pressed
        PropertyChanges {
            target: imageButton
            scale: .95
        }
    }
}

