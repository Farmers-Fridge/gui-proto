import QtQuick 2.4

Popup {
    id: popup
    popupId: "_checkout_"
    y: height

    // Border:
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 32
        border.color: _settings.appGreen
    }

    // Title:
    CommonText {
        anchors.top: parent.top
        anchors.topMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter
        color: _settings.appGreen
        text: _settings.shoppingCartTitle
        font.pixelSize: 24
        font.bold: true
    }

    // Back button:
    ImageButton {
        id: backButton
        source: "qrc:/qml/images/ico-back.png"
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        onClicked: mainApplication.hideCurrentPopup()
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: popup
            y: 0
        }
    }

    transitions: Transition {
        SpringAnimation {target: popup; property: "y"; duration: 500; spring: 3; damping: 0.2}
    }
}

