import QtQuick 2.5

Item {
    width: 8
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.margins: 6
    Rectangle {
        width: 1
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: _colors.ffToolBarSeparator1
    }
    Rectangle {
        width: 1
        height: parent.height
        anchors.horizontalCenterOffset: 1
        anchors.horizontalCenter: parent.horizontalCenter
        color: _colors.ffToolBarSeparator2
    }
}
