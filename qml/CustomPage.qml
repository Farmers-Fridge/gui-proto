import QtQuick 2.5

Page {
    property alias topBar: topBar.children
    property alias contents: contents.children
    property alias bottomBar: bottomBar.children
    property alias topBarHeight: topBar.height

    // Top bar:
    Item {
        id: topBar
        width: parent.width
        height: _settings.toolbarHeight
        anchors.top: parent.top
    }

    // Contents:
    Item {
        id: contents
        width: parent.width
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
    }

    // Bottom bar:
    Item {
        id: bottomBar
        width: parent.width
        height: _settings.toolbarHeight
        anchors.bottom: parent.bottom
    }
}

