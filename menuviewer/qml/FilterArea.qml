import QtQuick 2.5
import QtQuick.Layouts 1.1
import Common 1.0

RowLayout {
    id: row
    width: parent.width
    height: parent.height

    // Available filters:
    property variant availableFilters: ["Gluten Free", "Low Fat", "Low Calories", "Vegan", "Vegetarian"]

    Repeater {
        id: repeater
        model: availableFilters

        // Toggle button:
        ToggleButton {
            id: checkableFilter
            label: availableFilters[index]
            anchors.verticalCenter: parent.verticalCenter
            selected: _controller.currentFilter === availableFilters[index]
            onClicked: _controller.currentFilter = availableFilters[index]
        }
    }
}
