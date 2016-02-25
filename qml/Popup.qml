import QtQuick 2.4

Item {
    property string popupId: ""
    property bool isPopup: true
    property int idleTime: 0
    property alias contents: contents.children
    property alias title: title.text
    y: height

    // Background color:
    Rectangle {
        anchors.fill: parent
        color: _settings.popupBkgColor
    }

    // Border:
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 32
        border.color: _settings.appGreen

        Item {
            id: contents
            anchors.fill: parent
            anchors.margins: 96
        }
    }

    // Title:
    CommonText {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter
        color: _settings.appGreen
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

    // Time out:
    function onIdleTimeOut()
    {
        // Base impl does nothing:
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
