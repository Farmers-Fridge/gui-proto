import QtQuick 2.4
import "script/Utils.js" as Utils

Package {
    Item { id: listItem; Package.name: "list"; width: menuViewArea.width; height: menuViewArea.height }
    Item { id: gridItem; Package.name: "grid"; width: GridView.view.cellWidth; height: GridView.view.cellHeight }

    Item {
        id: menuImageWrapper
        visible: vendItemName !== "" ? true : false
        property double randomAngle: 0//Math.random()*12-6
        property double randomAngle2: 0//Math.random()*12-6

        // Width/Height:
        width: _settings.gridImageWidth
        height: _settings.gridImageHeight
        rotation: menuImageWrapper.randomAngle

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            property int w: menuImageWrapper.width
            property int h: menuImageWrapper.width
            property double s: Utils.calculateScale(w, h, menuImageWrapper.width)

            color: "white"; anchors.centerIn: parent; antialiasing: true
            width: w*s; height: h*s; visible: originalImage.status !== Image.Ready
            Rectangle {
                color: _settings.appGreen; antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Image loaded background:
        Rectangle {
            id: border; color: "white"; anchors.centerIn: parent; antialiasing: true
            width: originalImage.paintedWidth + 6; height: originalImage.paintedHeight + 6
            visible: !imageLoadingBkg.visible
        }

        BusyIndicator { anchors.centerIn: parent; on: originalImage.status !== Image.Ready; visible: on}

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            source: icon !== "" ? Utils.urlPublicStatic(icon) : ""
            //cache: true
            fillMode: Image.PreserveAspectFit
            width: menuImageWrapper.width
            height: menuImageWrapper.height

            Image {
                width: 128
                fillMode: Image.PreserveAspectFit
                rotation: 3
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
                visible: _viewState === "fullscreen"
                source: "qrc:/qml/images/ico-cardboard.png"
                antialiasing: true

                // Display price top right:
                CommonText {
                    anchors.centerIn: parent
                    color: "white"
                    text: price
                    font.pixelSize: 30
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gridItem.GridView.view.currentIndex = index
                    if (menuWrapper.state === "inGrid") {
                        menuWrapper.state = "fullscreen"
                    } else {
                         menuWrapper.state = "inGrid"
                    }
                }
            }
        }

        states: [
            State {
                name: "inGrid"; when: menuWrapper.state === "inGrid"
                ParentChange {
                    target: menuImageWrapper
                    parent: gridItem;
                    x: (gridItem.width-_settings.gridImageWidth)/2
                    y: (gridItem.height-_settings.gridImageHeight)/2
                    rotation: menuImageWrapper.randomAngle2
                }
            },
            State {
                name: "fullscreen"; when: menuWrapper.state === "fullscreen"
                ParentChange {
                    target: menuImageWrapper
                    parent: listItem
                }
                PropertyChanges {
                    target: menuImageWrapper
                    x: (menuViewArea.width-width)/2
                    y: 16
                    rotation: 0
                    width: menuViewArea.height-32
                    height: width
                }
                PropertyChanges { target: border; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "inGrid"; to: "fullscreen"
                SequentialAnimation {
                    ParentAnimation {
                        target: menuImageWrapper; via: foreground
                        NumberAnimation {
                            targets: [ menuImageWrapper, border ]
                            properties: "x,y,width,height,opacity,rotation"
                            duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: "OutQuart"
                        }
                    }
                }
            },
            Transition {
                from: "fullscreen"; to: "inGrid"

                ParentAnimation {
                    target: menuImageWrapper; via: foreground
                    NumberAnimation {
                        targets: [ menuImageWrapper, border ]
                        properties: "x,y,width,height,rotation,opacity"
                        duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: "OutQuart"
                    }
                }
            }
        ]
    }
}
