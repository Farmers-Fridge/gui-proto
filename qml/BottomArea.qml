import QtQuick 2.5
import QtQuick.Layouts 1.1

Rectangle {
    color: "transparent"
    border.color: _settings.green
    border.width: 1

    // Cancel button:
    MouseArea {
        id: cancelButton
        width: parent.height
        height: parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        onClicked: mainApplication.showKeyPad()
    }

    Row {
        anchors.fill: parent
        Item {
            width: parent.width/3
            height: parent.height
            CircularButton {
                color: "brown"
                anchors.centerIn: parent
                width: parent.height-32
                source: "qrc:/qml/images/ico-start-over.png"
                onClicked: _clearCartCommand.execute()
            }
        }
        Item {
            width: parent.width/3
            height: parent.height
            CircularButton {
                color: "brown"
                anchors.centerIn: parent
                width: parent.height-32
                source: "qrc:/qml/images/ico-login.png"
            }
        }
        Item {
            width: parent.width/3
            height: parent.height
            CircularButton {
                color: "brown"
                anchors.centerIn: parent
                width: parent.height-32
                source: "qrc:/qml/images/ico-checkout.png"
                onClicked: {
                    if (_controller.cartModel.cartTotal > 0)
                        mainApplication.showPopup("_checkout_")
                }
            }
        }
    }
}


