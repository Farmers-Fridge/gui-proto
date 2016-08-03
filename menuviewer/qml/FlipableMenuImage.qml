import QtQuick 2.5
import Common 1.0

Flipable {
    id: flipable
    width: 240
    height: 240
    property alias frontImage: frontImage.source
    property alias backImage: backImage.source
    property bool flipped: false
    property bool frontImageReady: frontImage.status !== Image.Loading
    property bool backImageReady: backImage.status !== Image.Loading

    // Timer:
    Timer {
        id: nutritionImageDisplayTimeOut
        interval: 3000
        onTriggered: {
            state = ""
            flipped = (state === "back")
        }
    }

    // Front image (menu image):
    front: Image {
        id: frontImage
        cache: true
        width: flipable.width
        height: flipable.height
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
    }

    // Back image (nutrition image):
    back: Image {
        id: backImage
        cache: true
        width: frontImage.width
        height: frontImage.height
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        onStatusChanged: {
            if (status === Image.Error)
                backImage.source = "qrc:/assets/ico-question.png"
        }
    }

    // Busy indicator:
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        on: (frontImage.status === Image.Loading)
        visible: on
    }

    // Define transform:
    transform: Rotation {
        id: rotation
        origin.x: flipable.width/2
        origin.y: flipable.height/2
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: 0
    }

    // Define states:
    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 }
        when: flipable.flipped
    }

    // Define transitions:
    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 500 }
    }

    // Handle nutrition image display timeout:
    onStateChanged: {
        if (state === "back")
            nutritionImageDisplayTimeOut.start()
        else
            nutritionImageDisplayTimeOut.stop()
    }
}
