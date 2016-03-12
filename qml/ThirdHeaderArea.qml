import QtQuick 2.4
import "script/Utils.js" as Utils

// Header:
Rectangle {
    id: header
    color: "transparent"
    border.color: _settings.appGreen
    border.width: 1

    // Category view:
    CategoryView {
        id: categoryView
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        enabled: _viewState === "inGrid"
    }
}

