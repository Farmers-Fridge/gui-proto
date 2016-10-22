import QtQuick 2.5

Item {
    id: root
    width: parent.width
    height: _settings.tabHeight

    property variant avStates: ["breakfast", "salads", "dishes", "drinks", "snacks"]
    state: "breakfast"
    signal tabClicked(string categoryName)
    Image {
        id: bkg
        anchors.fill: parent
        asynchronous: true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mouseY < _settings.tabClickableAreaHeight)
                {
                    var tabWidth = root.width/avStates.length
                    var tabIndex = Math.floor(mouseX/tabWidth)
                    root.state = avStates[tabIndex]
                    tabClicked(avStates[tabIndex])
                }
            }
        }
    }
    states: [
        State {
            name: "breakfast"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-breakfast-menu.png"
            }
        },
        State {
            name: "salads"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-salads-menu.png"
            }
        },
        State {
            name: "dishes"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-dishes-menu.png"
            }
        },
        State {
            name: "drinks"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-drinks-menu.png"
            }
        },
        State {
            name: "snacks"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-snacks-menu.png"
            }
        }
    ]
}

