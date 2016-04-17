import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import "script/Utils.js" as Utils

// Path view:
PathView {
    id: pathView
    pathItemCount: 2
    anchors.fill: parent
    highlightRangeMode: PathView.StrictlyEnforceRange
    snapMode: ListView.SnapOneItem
    interactive: false
    property int containerWidth: .75*width
    property int containerHeight: .75*height

    // Path:
    path: Path {
        startX: -width/2; startY: height/2
        PathLine {x: width + width/2; y:height/2 }
    }

    delegate: Item {
        id: imageDelegate
        visible: vendItemName !== ""
        width: pathView.width
        height: pathView.height

        Rectangle {
            id: container
            anchors.centerIn: parent
            color: "transparent"
            border.color: _settings.green
            width: containerWidth
            height: containerHeight

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
                source: icon !== "" ? Utils.urlPublicStatic(_appData.urlPublicRootValue, icon) : ""
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
                onStatusChanged:_appIsBusy = (originalImage.status === Image.Loading)
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

    // Navigation arrows:
    Item {
        width: parent.width
        height: containerHeight
        anchors.centerIn: parent

        // Previous button:
        CircularButton {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-prev.png"
            onClicked: mainApplication.navigateLeft()
            imageOffset: -8
        }

        // Next button:
        CircularButton {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/images/ico-next.png"
            onClicked: mainApplication.navigateRight()
            imageOffset: 8
        }
    }

    // Go to specific index:
    function gotoIndex(idx) {
        pathView.currentIndex = idx
    }

    // Navigate left:
    function onNavigateLeft()
    {
        var incr = 1
        var currentIndex = pathView.currentIndex
        currentIndex -= incr
        pathView.gotoIndex(currentIndex)
    }

    // Navigate right:
    function onNavigateRight()
    {
        var incr = 1
        var currentIndex = pathView.currentIndex
        currentIndex += incr
        pathView.gotoIndex(currentIndex)
    }

    // Handle navigation:
    Component.onCompleted: {
        mainApplication.navigateLeft.connect(onNavigateLeft)
        mainApplication.navigateRight.connect(onNavigateRight)
    }
}
