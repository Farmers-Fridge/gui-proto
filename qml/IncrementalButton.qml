import QtQuick 2.4

Item {
    width: 128
    height: 320
    property int value: 0
    property int minValue: 0
    property int maxValue: 50

    signal decrement()
    signal increment()

    // Increment:
    ImageButton {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/qml/images/ico-plus.png"
        onClicked: increment()
    }

    CommonText {
        anchors.centerIn: parent
        text: value
        font.pixelSize: 30
    }

    // Decrement:
    ImageButton {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/qml/images/ico-minus.png"
        onClicked: decrement()
    }

}

