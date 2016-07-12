import QtQuick 2.0
import Common 1.0

Item {
    anchors.fill: parent
    property alias subTotal: subTotalValue.text
    property alias tax: taxValue.text
    property alias total: totalValue.text
    property alias cartCount: cartCount.text
    Item {
        width: parent.width/2
        height: parent.height
        anchors.right: parent.right
        CommonText {
            id: subTotal
            text: qsTr("Subtotal")
            anchors.top: parent.top
            anchors.topMargin: 8
        }
        CommonText {
            id: subTotalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: subTotal.verticalCenter
        }
        CommonText {
            id: tax
            text: qsTr("Tax")
            anchors.verticalCenter: parent.verticalCenter
        }
        CommonText {
            id: taxValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: tax.verticalCenter
        }
        CommonText {
            id: total
            text: qsTr("Total")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
        }
        Item {
            anchors.left: total.right
            anchors.right: totalValue.left
            anchors.verticalCenter: total.verticalCenter
            CommonText {
                id: cartCount
                anchors.centerIn: parent
            }
        }
        CommonText {
            id: totalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: total.verticalCenter
        }
    }
}
