import QtQuick 2.5
import "script/Utils.js" as Utils

// Header:
Item {
    id: header

    // Category view:
    CategoryView {
        id: categoryView
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }
}

