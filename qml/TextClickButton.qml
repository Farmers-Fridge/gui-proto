import QtQuick 2.4

Rectangle {
    id: container
    width: _settings.buttonWidth
    height: _settings.buttonHeight
    radius: height
    opacity: enabled ? 1 : .5

    // Properties:
    property alias text: text.text

    // Set colors:
    color: _settings.unSelectedCategoryBkgColor

    // Selected signal:
    signal buttonClicked()

    // Text:
    CommonText {
        id: text
        anchors.centerIn: parent
        text: categoryName.toUpperCase()
        font.pixelSize: 42
        font.bold: true
        color: "white"
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
