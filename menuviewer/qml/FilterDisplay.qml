import QtQuick 2.5

Item {
    id: root
    width: parent.width
    height: _settings.tabHeight
    property variant avStates: ["No Filter", "Gluten Free", "Low Fat", "Low Calories", "Vegan", "Vegetarian"]
    signal filterSelected(string categoryName)
    state: "No Filter"
    onStateChanged: filterSelected(state)
    signal filterClicked(string categoryName)
    Image {
        id: bkg
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var filterIndex = 0
                if ((mouseX >= 0) && (mouseX <= 128))
                    filterIndex = 1
                else
                if ((mouseX >= 165) && (mouseX <= 255))
                    filterIndex = 2
                else
                if ((mouseX >= 301) && (mouseX <= 475))
                    filterIndex = 3
                else
                if ((mouseX >= 475) && (mouseX <= 550))
                    filterIndex = 4
                else
                if ((mouseX >= 590) && (mouseX <= 710))
                    filterIndex = 5

                if (avStates[filterIndex] === root.state)
                    root.state = "No Filter"
                else {
                    root.state = avStates[filterIndex]
                    filterClicked(avStates[filterIndex])
                }
            }
        }
    }
    states: [
        State {
            name: "No Filter"
            PropertyChanges {
                target: bkg
                source: "qrc:/assets/ico-nofilter-selected.png"
            }
        },
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

