import QtQuick 2.5

Rectangle {
    id: container
    width: _settings.buttonWidth
    height: _settings.buttonHeight
    radius: height
    opacity: enabled ? 1 : .5

    // Properties:
    property alias text: text.text
    property string selectedBkgColor: _settings.selectedCategoryBkgColor
    property string unSelectedBkgColor: _settings.green
    property string selectedTextColor: _settings.green
    property string unselectedTextColor: "white"
    property bool selected: false

    // Set colors:
    color: selected ? selectedBkgColor : unSelectedBkgColor

    // Selected signal:
    signal buttonClicked()

    // Text:
    CommonText {
        id: text
        anchors.centerIn: parent
        text: categoryName.toUpperCase()
        font.pixelSize: parent.height-32
        font.bold: true
        color: selected ? selectedTextColor : unselectedTextColor
    }

    // Mouse area:
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: buttonClicked()
    }

    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: container
            scale: .95
        }
    }
}
