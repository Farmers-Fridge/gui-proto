import QtQuick 2.4

Item {
    width: 104
    height: 32
    property int value: 0
    property int minValue: 0
    property int maxValue: 50

    signal decrement()
    signal increment()

    Item {
        id: minusButton
        width: parent.height
        height: width
        Image {
            anchors.fill: parent
            anchors.margins: 4
            source: "qrc:/qml/images/ico-minus.png"
        }
        states: State {
            name: "pressed"
            when: mouseArea1.pressed
            PropertyChanges {
                target: minusButton
                scale: .95
            }
        }
        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onClicked: decrement()
        }
    }

    Item {
        anchors.left: minusButton.right
        anchors.leftMargin: 3
        anchors.right: addButton.left
        anchors.rightMargin: 3
        height: parent.height
        CommonText {
            anchors.centerIn: parent
            text: value
        }
    }

    Item {
        id: addButton
        width: parent.height
        height: width
        anchors.right: parent.right
        Image {
            anchors.fill: parent
            anchors.margins: 4
            source: "qrc:/qml/images/ico-plus.png"
        }
        states: State {
            name: "pressed"
            when: mouseArea2.pressed
            PropertyChanges {
                target: addButton
                scale: .95
            }
        }
        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: increment()
        }
    }
}

