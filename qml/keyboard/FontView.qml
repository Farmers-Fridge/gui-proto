import QtQuick 2.5
import QtQuick.Controls 1.2

Rectangle {
    id: fontView
    color: _colors.ffWhite
    border.color: _colors.ffGray
    border.width: 3
    x: alphaNumericKeyPad.x + alphaNumericKeyPad.width - width
    property int currentIndex: -1
    property bool special: false

    // Font selected:
    signal fontSelected(int fontIndex)

    function setCurrentIndex(index)
    {
        listView.positionViewAtIndex(index, ListView.Contain)
        currentIndex = index
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 3
        ListView {
            id: listView
            anchors.fill: parent
            model: Qt.fontFamilies()
            clip: true
            snapMode: ListView.SnapOneItem
            delegate: Rectangle {
                width: parent.width
                height: 48
                color: index == currentIndex ? "orange" : "white"
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData
                    font.pixelSize: 18
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentIndex = index
                        fontSelected(index)
                    }
                }
            }
        }
    }

    states: State {
        name: "on"
        PropertyChanges {
            target: fontView
            x: alphaNumericKeyPad.x + alphaNumericKeyPad.width
        }
    }

    Behavior on x {
        PropertyAnimation {duration: _settings.keyboardAnimDuration}
    }
}

