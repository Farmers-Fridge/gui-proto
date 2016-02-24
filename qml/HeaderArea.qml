import QtQuick 2.4

// Header:
Item {
    id: header

    // Logo:
    Image {
        anchors.centerIn: parent
        source: "qrc:/qml/images/ico-logo.png"
    }

    // Cancel button:
    ImageButton {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-cancel.png"
        onClicked: _exitCommand.execute()
    }

    // Checkout button:
    ImageButton {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/images/ico-checkout.png"
        onClicked: _checkOutCommand.execute()
    }
}

