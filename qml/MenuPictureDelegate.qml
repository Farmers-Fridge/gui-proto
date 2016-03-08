import QtQuick 2.4
import "script/Utils.js" as Utils

Package {
    Item { id: listItem; Package.name: "list"; width: menuViewArea.width; height: menuViewArea.height }
    Item { id: gridItem; Package.name: "grid"; width: GridView.view.cellWidth; height: GridView.view.cellHeight }

    Item {
        id: menuImageWrapper
        visible: vendItemName !== "" ? true : false
        property int imageMargin: 20
        property double randomAngle: Math.random()*12-6
        property double randomAngle2: Math.random()*12-6

        // Width/Height:
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
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
            cache: true
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
                    if (menuWrapper.state === "inGrid") {
                        gridItem.GridView.view.currentIndex = index
                        menuWrapper.state = "fullscreen"
                    } else {
                        gridItem.GridView.view.currentIndex = index;
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
                    parent: gridItem; x: 10; y: 10
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
                ScriptAction {
                    script: menuImageWrapper.anchors.centerIn = undefined
                }
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
