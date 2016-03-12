import QtQuick 2.4

// Menu wrapper:
Item {
    id: menuWrapper
    Package.name: "browser"
    state: "inGrid"
    onStateChanged: _viewState = state
    property variant model

    // View component:
    Component {
        id: viewComponent
        GridView {
            id: itemView
            model: menuWrapper.model
            anchors.fill: parent
            interactive: false
            onCurrentIndexChanged: photosListView.positionViewAtIndex(currentIndex, ListView.Contain)
            visible: _controller.currentCategory === categoryName
            function onModelReady()
            {
                var nItems = categoryListModel.count
                if (nItems === 1)
                {
                    cellWidth = menuViewArea.width
                    cellHeight = menuViewArea.height
                }
                else
                if (nItems === 2)
                {
                    cellWidth = menuViewArea.width/2
                    cellHeight = menuViewArea.height
                }
                else
                if (nItems === 3)
                {
                    cellWidth = menuViewArea.width/3
                    cellHeight = menuViewArea.height/1
                }
                else
                if (nItems === 4)
                {
                    cellWidth = menuViewArea.width/2
                    cellHeight = menuViewArea.height/2
                }
                else
                if (nItems === 5)
                {
                    cellWidth = menuViewArea.width/3
                    cellHeight = menuViewArea.height/2
                }
                else
                if (nItems === 6)
                {
                    cellWidth = menuViewArea.width/3
                    cellHeight = menuViewArea.height/2
                }
                else
                if (nItems === 7)
                {
                    cellWidth = menuViewArea.width/4
                    cellHeight = menuViewArea.height/2
                }
                else
                if (nItems === 8)
                {
                    cellWidth = menuViewArea.width/4
                    cellHeight = menuViewArea.height/2
                }
                else
                if (nItems === 9)
                {
                    cellWidth = menuViewArea.width/3
                    cellHeight = menuViewArea.height/3
                }
            }

            Component.onCompleted: {
                categoryListModel.modelReady.connect(onModelReady)
            }
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
