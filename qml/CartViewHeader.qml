import QtQuick 2.5

// Header:
Rectangle {
    id: header
    anchors.top: parent.top
    width: parent.width
    height: _settings.checkOutPopupHeaderHeight
    color: _settings.cartViewHeaderColor

    // First col:
    Item {
        id: firstCol
        width: parent.width*2/5
        height: parent.height
        CommonText {
            anchors.centerIn: parent
            text: qsTr("PRODUCT")
            color: "white"
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: firstCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    // Second col:
    Item {
        id: secondCol
        width: parent.width/5
        height: parent.height
        anchors.left: firstCol.right
        CommonText {
            anchors.centerIn: parent
            text: qsTr("QTY")
            color: "white"
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: secondCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    // Third col:
    Item {
        id: thirdCol
        width: parent.width/5
        height: parent.height
        anchors.left: secondCol.right
        CommonText {
            anchors.centerIn: parent
            text: qsTr("TOTAL")
            color: "white"
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: thirdCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    // Fourth col:
    Item {
        id: fourthCol
        width: parent.width/5
        height: parent.height
        anchors.left: thirdCol.right
        CommonText {
            anchors.centerIn: parent
            text: qsTr("ACTION")
            color: "white"
        }
    }
}

