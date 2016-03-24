import QtQuick 2.4
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
        enabled: _viewState === "inGrid"
    }
}

