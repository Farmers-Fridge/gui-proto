import QtQuick 2.5

// Header:
Rectangle {
    id: header
    anchors.top: parent.top
    width: parent.width
    height: _generalSettings.checkOutPopupHeaderHeight
    color: _colors.ffBrown

    // First col:
    Item {
        id: firstCol
        width: parent.width*2/5
        height: parent.height
        CommonText {
            anchors.centerIn: parent
            text: qsTr("PRODUCT")
            color: _colors.ffWhite
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: firstCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: _colors.ffWhite
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
            color: _colors.ffWhite
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: secondCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: _colors.ffWhite
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
            color: _colors.ffWhite
        }
    }

    // Separator:
    Rectangle {
        width: 1
        height: parent.height-8
        anchors.left: thirdCol.right
        anchors.verticalCenter: parent.verticalCenter
        color: _colors.ffWhite
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
            color: _colors.ffWhite
        }
    }
}

