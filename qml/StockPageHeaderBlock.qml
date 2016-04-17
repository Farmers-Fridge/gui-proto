import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4

Item {
    id: foot
    property bool good: false

    Repeater {
        model: xmlVersionModel
        delegate: Item {
            id: container
            width: foot.width
            height: foot.height
            CommonText {
                anchors.centerIn: container
                font.pixelSize: 28
                text: versionModel + " " + statusModel
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
            Component.onCompleted: foot.good = (statusModel.substr(0,4) !== "Fail")
        }
    }
}

