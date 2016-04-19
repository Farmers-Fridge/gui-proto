import QtQuick 2.5

Item {
    id: styledTitle
    property string color: _settings.green
    property alias title: title.text

    // Horizontal line:
    Line {
        anchors.centerIn: parent
        color: styledTitle.color
    }

    // Title area:
    Rectangle {
        id: titleArea
        implicitWidth: title.paintedWidth+32
        height: parent.height
        anchors.centerIn: parent
        color: _settings.mainWindowColor

        // Title:
        CommonText {
            id: title
            color: styledTitle.color
            anchors.centerIn: parent
            font.pixelSize: 24
        }
    }
}
