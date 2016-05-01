import QtQuick 2.5

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
        interval: _timeSettings.nutritionImageDisplayTimeOut
        onTriggered: {
            state = ""
            flipped = (state === "back")
        }
    }

    // Front image (menu image):
    front: Image { id: frontImage; anchors.centerIn: parent }

    // Back image (nutrition image):
    back: Image {
        id: backImage
        anchors.centerIn: parent
        onStatusChanged: {
            if (status === Image.Error)
                backImage.source = "qrc:/qml/images/ico-question.png"
        }
    }

    // Busy indicator:
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        on: (frontImage.status === Image.Loading)
        visible: on
        z: _generalSettings.zMax
    }

    transform: Rotation {
        id: rotation
        origin.x: flipable.width/2
        origin.y: flipable.height/2
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: 0
    }

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 }
        when: flipable.flipped
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: _timeSettings.widgetAnimationDuration }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: flipable.flipped = !flipable.flipped
        enabled: frontImageReady && backImageReady
    }

    onStateChanged: {
        if (state === "back")
            nutritionImageDisplayTimeOut.start()
        else
            nutritionImageDisplayTimeOut.stop()
    }
}
