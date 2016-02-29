import QtQuick 2.4

Item {
    width: 320
    height: 128
    property int value: 0
    property int minValue: 0
    property int maxValue: 50

    signal decrement()
    signal increment()

    // Decrement:
    ImageButton {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-minus.png"
        onClicked: decrement()
    }

    CommonText {
        anchors.centerIn: parent
        text: value
        font.pixelSize: 30
    }

    // Increment:
    ImageButton {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-plus.png"
        onClicked: increment()
    }
}

