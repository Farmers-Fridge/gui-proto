import QtQuick 2.5

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
        width: 48
        height: 48
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/qml/images/ico-minus.png"
        onClicked: decrement()
    }

    // Value:
    CommonText {
        anchors.centerIn: parent
        text: value
    }

    // Decrement:
    ImageButton {
        width: 48
        height: 48
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/qml/images/ico-plus.png"
        onClicked: increment()
    }
}

