import QtQuick 2.4
import "script/Utils.js" as Utils

/*
Package {
    Item { id: listItem; Package.name: "list"; width: mainWindow.width + 40; height: _settings.gridImageHeight }
    Item { id: gridItem; Package.name: "grid"; width: mainWindow.width + 40; height: _settings.gridImageHeight }
    Item {
        id: menuImageWrapper
        property int imageMargin: 20
        property double randomAngle: Math.random()*13-6
        property double randomAngle2: Math.random()*13-6

        // Width/Height:
        width: _settings.gridImageWidth
        height: _settings.gridImageHeight-imageMargin
        rotation: menuImageWrapper.randomAngle

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            property int w: menuImageWrapper.width
            property int h: menuImageWrapper.height
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

        Rectangle {
            id: nutritionFactContainer
            color: "white"
            width: menuImageWrapper.width
            height: menuImageWrapper.height
            x: (nutrition !== "") ? originalImage.x + originalImage.width : originalImage.x
            Image {
                id: nutritionfactImage
                anchors.fill: parent
                antialiasing: true
                source: nutrition !== "" ? Utils.urlPublicStatic(nutrition) : ""
                cache: true
                fillMode: Image.PreserveAspectFit
            }
            visible: (nutrition !== "") && (_viewState === "fullscreen")
        }

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            source: Utils.urlPublicStatic(icon)
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
                ParentChange { target: menuImageWrapper; parent: gridItem; x: 10; y: 10; rotation: menuImageWrapper.randomAngle2 }
            },
            State {
                name: "fullscreen"; when: menuWrapper.state === "fullscreen"
                ParentChange {
                    target: menuImageWrapper
                    parent: listItem
                }
                PropertyChanges {
                    target: menuImageWrapper
                    x: (menuViewArea.width-((nutrition === "") ? 1 : 2)*width)/2
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
*/

Package {
    Item { id: listItem; Package.name: "list"; width: mainWindow.width + 40; height: _settings.gridImageHeight }
    Item { id: gridItem; Package.name: "grid"; width: mainWindow.width + 40; height: _settings.gridImageHeight }
    Item {
        id: menuImageWrapper
        property int imageMargin: 20
        property double randomAngle: Math.random()*12-6
        property double randomAngle2: Math.random()*12-6

        // Width/Height:
        width: _settings.gridImageWidth
        height: _settings.gridImageHeight-imageMargin
        rotation: menuImageWrapper.randomAngle

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            property int w: menuImageWrapper.width
            property int h: menuImageWrapper.height
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
            source: Utils.urlPublicStatic(icon)
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
                ParentChange { target: menuImageWrapper; parent: gridItem; x: 10; y: 10; rotation: menuImageWrapper.randomAngle2 }
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
