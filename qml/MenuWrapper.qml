import QtQuick 2.4

// Menu wrapper:
Item {
    id: menuWrapper
    Package.name: "browser"
    state: "inGrid"
    onStateChanged: _viewState = state

    // View component:
    Component {
        id: viewComponent
        GridView {
            id: itemView
            model: visualModel.parts.grid
            anchors.fill: parent
            cellWidth: _settings.gridImageWidth; cellHeight: _settings.gridImageHeight
            interactive: false
            onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
            visible: _controller.currentCategory === categoryName
        }
    }

    // View loader:
    Loader {
        id: viewLoader
        width: mainWindow.width; height: mainWindow.height
    }

    MouseArea {
        anchors.fill: parent
        onClicked: menuWrapper.state = "fullscreen"
    }

    // Go back to main page:
    function onGoBackToMainPage()
    {
        menuWrapper.state = "inGrid"
    }

    // Connections:
    Component.onCompleted: {
        viewLoader.sourceComponent = viewComponent
        mainApplication.goBackToMainPage.connect(onGoBackToMainPage)
    }
}
