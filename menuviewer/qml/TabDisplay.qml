import QtQuick 2.5

Item {
    id: root
    width: parent.width
    height: _settings.tabHeight
    property variant avStates: ["Breakfast", "Salads", "Dishes", "Drinks", "Snacks"]
    signal categorySelected(string categoryName)
    state: "Breakfast"
    onStateChanged: categorySelected(state)
    signal tabClicked(string categoryName)
    Image {
        id: bkg
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var tabWidth = root.width/avStates.length
                var tabIndex = Math.floor(mouseX/tabWidth)
                root.state = avStates[tabIndex]
                tabClicked(avStates[tabIndex])
            }
        }
    }
    states: [
        State {
            name: "Breakfast"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-breakfast-menu.png"
            }
        },
        State {
            name: "Salads"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-salads-menu.png"
            }
        },
        State {
            name: "Dishes"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-dishes-menu.png"
            }
        },
        State {
            name: "Drinks"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-drinks-menu.png"
            }
        },
        State {
            name: "Snacks"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-snacks-menu.png"
            }
        }
    ]
}

