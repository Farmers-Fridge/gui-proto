import QtQuick 2.5
import QtQuick.Window 2.0

Item {
    id: singleItemView
    visible: vendItemName !== ""
    property alias imageUrl: originalImage.source

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
                    anchors.centerIn: parent
                    color: "white"
                    text: price
                }
            }
            onStatusChanged: _appIsBusy = (originalImage.status === Image.Loading)
        }
    }

    Row {
        anchors.top: container.bottom
        anchors.bottom: parent.bottom
        width: container.width
        anchors.horizontalCenter: container.horizontalCenter

        Item {
            width: parent.width/2
            height: parent.height

            // Return to salads:
            TextClickButton {
                id: returnToSaladsButton
                width: (384/_settings.refScreenWidth)*Screen.desktopAvailableWidth
                text: _settings.returnToSaladsText
                anchors.centerIn: parent
                onButtonClicked: mainApplication.loadGridView(index)
            }
        }

        Item {
            width: parent.width/2
            height: parent.height

            // Add to cart:
            TextClickButton {
                id: addToCartButton
                width: (384/_settings.refScreenWidth)*Screen.desktopAvailableWidth
                text: _settings.addToCartText
                anchors.centerIn: parent
                onButtonClicked: {
                    _addToCartCommand.currentItem = categoryListModel.get(index)
                    _addToCartCommand.execute()
                }
            }
        }
    }
}
