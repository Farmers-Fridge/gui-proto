import QtQuick 2.5

Item {
    id: root
    width: parent.width
    height: _settings.tabHeight
    property variant avStates: ["Gluten Free", "Low Fat", "Low Calories", "Vegan", "Vegetarian"]
    signal filterSelected(string categoryName)
    state: "Gluten Free"
    onStateChanged: filterSelected(state)
    signal filterClicked(string categoryName)
    Image {
        id: bkg
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var filterWidth = bkg.width/avStates.length
                var filterIndex = Math.floor(mouseX/filterWidth)
                root.state = avStates[filterIndex]
                filterClicked(avStates[filterIndex])
            }
        }
    }
    states: [
        State {
            name: "Gluten Free"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-gluten-free-selected.png"
            }
        },
        State {
            name: "Low Fat"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-lowfat-selected.png"
            }
        },
        State {
            name: "Low Calories"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-lowcal-selected.png"
            }
        },
        State {
            name: "Vegan"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-vegan-selected.png"
            }
        },
        State {
            name: "Vegetarian"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-vegetarian-selected.png"
            }
        }
    ]
}

