import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    // Background:
    Image {
        anchors.fill: parent
        source: "qrc:/qml/images/ico-bottom-bg.png"
        smooth: true
    }

    Row {
        anchors.fill: parent
        Item {
            width: parent.width/3
            height: parent.height
            ImageButton {
                anchors.centerIn: parent
                source: "qrc:/qml/images/ico-start-over.png"
                onClicked: _clearCartCommand.execute()
            }
        }
        Item {
            width: parent.width/3
            height: parent.height
            ImageButton {
                anchors.centerIn: parent
                source: "qrc:/qml/images/ico-login.png"
            }
        }
        Item {
            width: parent.width/3
            height: parent.height
            CircularButton {
                anchors.centerIn: parent
                size: parent.height-32
                source: "qrc:/qml/images/ico-checkout.png"
                onClicked: {
                    if (_controller.cartModel.cartTotal > 0)
                        mainApplication.showPopup("_checkoutpopup_")
                }
            }
        }
    }
}


