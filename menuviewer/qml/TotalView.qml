import QtQuick 2.5
import Common 1.0

Item {
    property alias subTotal: subTotalValue.text
    property alias tax: taxValue.text
    property alias total: totalValue.text
    property alias cartCount: cartCount.text

    Item {
        width: parent.width/2
        height: parent.height
        anchors.right: parent.right
        StandardText {
            id: subTotal
            text: qsTr("Subtotal")
            anchors.top: parent.top
            anchors.topMargin: 8
        }
        StandardText {
            id: subTotalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: subTotal.verticalCenter
        }
        StandardText {
            id: tax
            text: qsTr("Tax")
            anchors.top: subTotal.bottom
            anchors.topMargin: 8
        }
        StandardText {
            id: taxValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: subTotal.bottom
            anchors.topMargin: 8
        }
        StandardText {
            id: total
            text: qsTr("Total")
            anchors.top: tax.bottom
            anchors.topMargin: 8
        }
        Item {
            anchors.left: total.right
            anchors.right: totalValue.left
            anchors.verticalCenter: total.verticalCenter
            StandardText {
                id: cartCount
                anchors.centerIn: parent
            }
        }
        StandardText {
            id: totalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: tax.bottom
            anchors.topMargin: 8
        }
    }
}
