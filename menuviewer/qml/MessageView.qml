import QtQuick 2.5
import Common 1.0

ListView {
    id: messageView
    anchors.fill: parent
    clip: true
    spacing: 8
    delegate: Item {
        width: parent.width
        height: 48

        // Message display:
        Item {
            id: messageLabel
            width: parent.width
            height: parent.height

            StandardText {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: msgText
                color: getMsgColor(index)

                // Get message color:
                function getMsgColor(index)
                {
                    // OK:
                    if (msgType === 0)
                        return "green"
                    // Warning:
                    if (msgType === 1)
                        return "blue"
                    // Error:
                    if (msgType === 2)
                        return "red"
                    // Info:
                    if (msgType === 3)
                        return "cyan"
                    // Need update:
                    if (msgType === 4)
                        return "red"
                    // Don't need update:
                    if (msgType === 5)
                        return "green"
                    if (msgType === 6)
                        return "brown"
                    return "black"
                }
            }
        }
    }
}
