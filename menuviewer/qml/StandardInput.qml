import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

Item {
    id: standardInput
    property alias title: title.text
    property string placeHolderText
    CommonText {
        id: title
        width: parent.width
        anchors.top: parent.top
    }
    TextField {
        id: input
        placeholderText: standardInput.placeHolderText
        font.pixelSize: 28
        width: parent.width
        anchors.top: title.bottom
        anchors.topMargin: 8
    }
}
