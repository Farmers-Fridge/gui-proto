import QtQuick 2.0
import Common 1.0

Item {
    property alias subTotal: subTotalValue.text
    property alias tax: taxValue.text
    property alias total: totalValue.text
    property alias cartCount: cartCount.text
    property int fontPixelSize: 24

    Item {
        width: parent.width/2
        height: parent.height
        anchors.right: parent.right
        CommonText {
            id: subTotal
            text: qsTr("Subtotal")
            anchors.top: parent.top
            anchors.topMargin: 8
            font.pixelSize: fontPixelSize
        }
        CommonText {
            id: subTotalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: subTotal.verticalCenter
            font.pixelSize: fontPixelSize
        }
        CommonText {
            id: tax
            text: qsTr("Tax")
            anchors.top: subTotal.bottom
            anchors.topMargin: 8
            font.pixelSize: fontPixelSize
        }
        CommonText {
            id: taxValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: subTotal.bottom
            anchors.topMargin: 8
            font.pixelSize: fontPixelSize
        }
        CommonText {
            id: total
            text: qsTr("Total")
            anchors.top: tax.bottom
            anchors.topMargin: 8
            font.pixelSize: fontPixelSize
        }
        Item {
            anchors.left: total.right
            anchors.right: totalValue.left
            anchors.top: tax.bottom
            anchors.topMargin: 8
            CommonText {
                id: cartCount
                anchors.centerIn: parent
                font.pixelSize: fontPixelSize
            }
        }
        CommonText {
            id: totalValue
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: tax.bottom
            anchors.topMargin: 8
            font.pixelSize: fontPixelSize
        }
    }
}
