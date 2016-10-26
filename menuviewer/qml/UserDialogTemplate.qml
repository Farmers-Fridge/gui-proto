import QtQuick 2.5
import QtQuick.Controls 1.4
import Common 1.0

DialogTemplate {
    id: userDialogTemplate
    property alias model: userListView.model
    property int blockSize: 96
    width: 512
    implicitHeight: (model.count+1)*blockSize

    // User area:
    contents: Item {
        id: userArea
        anchors.fill: parent
        ListView {
            id: userListView
            anchors.fill: parent
            anchors.margins: 8
            clip: true
            spacing: 8
            interactive: false
            delegate: StandardInput {
                width: parent.width
                height: 96
                title: inputTitle
                placeHolderText: inputPlaceHolder
            }
        }
    }
}
