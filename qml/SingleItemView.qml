import QtQuick 2.5
import QtQuick.Window 2.0

Item {
    id: singleItemView
    visible: vendItemName !== ""
    property alias itemUrl: originalImage.source
    property alias itemPrice: priceText.text

    Rectangle {
        id: container
        anchors.centerIn: parent
        color: "transparent"
        border.color: _settings.green
        width: parent.width*.75
        height: parent.height*.75

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: "white"
            anchors.centerIn: parent
            antialiasing: true
            width: Math.min(parent.width, parent.height)
            height: width
            visible: originalImage.status !== Image.Ready
            Rectangle {
                color: _settings.green
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            cache: true
            fillMode: Image.PreserveAspectFit
            width: imageLoadingBkg.width
            height: imageLoadingBkg.height
            anchors.centerIn: parent
            Image {
                width: 128
                fillMode: Image.PreserveAspectFit
                rotation: 3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8
                source: "qrc:/qml/images/ico-cardboard.png"
                antialiasing: true

                // Display price top right:
                CommonText {
                    id: priceText
                    anchors.centerIn: parent
                    color: "white"
                }
            }
            //onStatusChanged: _appIsBusy = (originalImage.status === Image.Loading)
        }
    }

    Item {
        anchors.top: container.bottom
        anchors.bottom: parent.bottom
        width: container.width
        anchors.horizontalCenter: container.horizontalCenter

        // Return to salads:
        ImageButton {
            id: returnToSaladsButton
            anchors.right: separator.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-return-to-salads.png"
            onClicked: mainApplication.loadGridView(index)
        }

        // Separator:
        Item {
            id: separator
            anchors.centerIn: parent
            width: 1
            height: parent.height
        }

        // Add to cart:
        ImageButton {
            id: addToCartButton
            source: "qrc:/qml/images/ico-add-to-cart.png"
            anchors.left: separator.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                _addToCartCommand.currentItem = categoryListModel.get(index)
                _addToCartCommand.execute()
            }
        }
    }
}
