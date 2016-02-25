import QtQuick 2.4
import "script/Utils.js" as Utils

Package {
    Item { id: stackItem; Package.name: 'stack'; width: 160; height: 153; z: stackItem.PathView.z }
    Item { id: listItem; Package.name: 'list'; width: mainWindow.width + 40; height: 153 }
    Item { id: gridItem; Package.name: 'grid'; width: 160; height: 153 }
    Item {
        id: photoWrapper

        property double randomAngle: Math.random()*13-6
        property double randomAngle2: Math.random()*13-6

        // Nutrition fact timer:
        Timer {
            id: nutritionFactTimer
            interval: _settings.nutritionFactTimer
            onTriggered: nutritionFactContainer.state = ""
            repeat: false
        }

        x: 0; y: 0; width: 140; height: 133
        z: stackItem.PathView.z; rotation: photoWrapper.randomAngle

        // Image loading background
        Rectangle {
            id: imageLoadingBkg

            property int w: photoWrapper.width;
            property int h: photoWrapper.height
            property double s: Utils.calculateScale(w, h, photoWrapper.width)

            color: "white"; anchors.centerIn: parent; antialiasing: true
            width: w*s; height: h*s; visible: originalImage.status != Image.Ready
            Rectangle {
                color: "#878787"; antialiasing: true
                anchors { fill: parent; topMargin: 3; bottomMargin: 3; leftMargin: 3; rightMargin: 3 }
            }
        }

        Rectangle {
            id: border; color: "white"; anchors.centerIn: parent; antialiasing: true
            width: originalImage.paintedWidth + 6; height: originalImage.paintedHeight + 6
            visible: !imageLoadingBkg.visible
        }

        BusyIndicator { anchors.centerIn: parent; on: originalImage.status != Image.Ready }
        Image {
            id: originalImage
            antialiasing: true
            source: Utils.urlPublicStatic(icon)
            cache: false
            fillMode: Image.PreserveAspectFit
            width: photoWrapper.width
            height: photoWrapper.height
        }
        Rectangle {
            id: nutritionFactContainer
            color: "white"
            width: photoWrapper.width
            height: photoWrapper.height
            opacity: 0
            Image {
                id: nutritionfactImage
                anchors.fill: parent
                antialiasing: true
                source: nutrition !== "" ? Utils.urlPublicStatic(nutrition) : ""
                visible: nutrition !== ""
                cache: false
                fillMode: Image.PreserveAspectFit
            }
            states: State {
                name: "on"
                PropertyChanges {
                    target: nutritionFactContainer
                    opacity: 1
                }
            }
            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }
        Rectangle {
            color: "transparent"
            border.color: _settings.appGreen
            border.width: 3
            width: originalImage.width*1.5
            height: originalImage.height
            anchors.centerIn: originalImage
            visible: viewState === "fullscreen"

            // Question:
            ImageButton {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-question.png"
                onClicked: {
                    nutritionFactTimer.start()
                    if (nutritionFactContainer.state === "")
                        nutritionFactContainer.state = "on"
                    else
                        nutritionFactContainer.state = ""
                }
            }

            // Add:
            ImageButton {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qml/images/ico-plus.png"
            }
        }

        MouseArea {
            width: originalImage.paintedWidth; height: originalImage.paintedHeight; anchors.centerIn: originalImage
            onClicked: {
                if (albumWrapper.state == 'inGrid') {
                    gridItem.GridView.view.currentIndex = index;
                    albumWrapper.state = 'fullscreen'
                } else {
                    gridItem.GridView.view.currentIndex = index;
                    albumWrapper.state = 'inGrid'
                }
            }
        }

        states: [
            State {
                name: 'stacked'; when: albumWrapper.state == ''
                ParentChange { target: photoWrapper; parent: stackItem; x: 10; y: 10 }
                PropertyChanges { target: photoWrapper; opacity: stackItem.PathView.onPath ? 1.0 : 0.0 }
            },
            State {
                name: 'inGrid'; when: albumWrapper.state == 'inGrid'
                ParentChange { target: photoWrapper; parent: gridItem; x: 10; y: 10; rotation: photoWrapper.randomAngle2 }
            },
            State {
                name: 'fullscreen'; when: albumWrapper.state == 'fullscreen'
                ParentChange {
                    target: photoWrapper
                    parent: listItem
                    x: (menuViewArea.width-width)/2; y: 16
                    rotation: 0
                    width: menuViewArea.height-32
                    height: width
                }
                PropertyChanges { target: border; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                from: 'stacked'; to: 'inGrid'
                SequentialAnimation {
                    PauseAnimation { duration: 10 * index }
                    ParentAnimation {
                        target: photoWrapper; via: foreground
                        NumberAnimation {
                            target: photoWrapper; properties: 'x,y,rotation,opacity'; duration: 600; easing.type: 'OutQuart'
                        }
                    }
                }
            },
            Transition {
                from: 'inGrid'; to: 'stacked'
                ParentAnimation {
                    target: photoWrapper; via: foreground
                    NumberAnimation { properties: 'x,y,rotation,opacity'; duration: 600; easing.type: 'OutQuart' }
                }
            },
            Transition {
                from: 'inGrid'; to: 'fullscreen'
                SequentialAnimation {
                    ParentAnimation {
                        target: photoWrapper; via: foreground
                        NumberAnimation {
                            targets: [ photoWrapper, border ]
                            properties: 'x,y,width,height,opacity,rotation'
                            duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: 'OutQuart'
                        }
                    }
                }
            },
            Transition {
                from: 'fullscreen'; to: 'inGrid'
                ParentAnimation {
                    target: photoWrapper; via: foreground
                    NumberAnimation {
                        targets: [ photoWrapper, border ]
                        properties: 'x,y,width,height,rotation,opacity'
                        duration: gridItem.GridView.isCurrentItem ? 600 : 1; easing.type: 'OutQuart'
                    }
                }
            }
        ]
    }
}
