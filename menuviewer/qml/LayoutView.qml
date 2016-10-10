import QtQuick 2.5

Item {
    id: layoutView
    property alias model: listView.model
    property int selectedLayout: 0
    property int rectXMin: 0
    property int rectYMin: 0
    property var topLeftCell
    property int startIndex
    property int endIndex

    Item {
        id: rootContainer
        width: listView.width + gridView.width
        height: parent.height*.9
        anchors.centerIn: parent
        ListView {
            id: listView
            interactive: false
            width: parent.height/_layoutMgr.nLayouts
            height: parent.height
            delegate: Rectangle {
                width: height
                height: listView.width
                color: "gray"
                border.color: index === listView.currentIndex ? "orange" : "gray"
                border.width: 3
                Rectangle {
                    id: innerRect
                    anchors.fill: parent
                    anchors.margins: 8
                    color: "gray"
                    Text {
                        anchors.centerIn: parent
                        text: index+1
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listView.currentIndex = index
                            _layoutMgr.currentLayout = index
                        }
                    }
                }
            }
        }

        // Grid view:
        GridView {
            id: gridView
            interactive: false
            anchors.left: listView.right
            width: parent.height
            height: parent.height
            model: _layoutMgr.maxImages
            cellWidth: width/3
            cellHeight: height/3

            // Top left pos:
            function topLeftPos()
            {
                var x0 = topLeftCell.mapToItem(gridView, topLeftCell.x, topLeftCell.y).x
                var y0 = topLeftCell.mapToItem(gridView, topLeftCell.x, topLeftCell.y).y
                var x1 = Math.round(gridView.mapToItem(rootContainer, x0, y0).x)
                var y1 = Math.round(gridView.mapToItem(rootContainer, x0, y0).y)
                var p = rootContainer.mapToItem(layoutView, x1, y1)
                return p
            }

            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight
                Rectangle {
                    id: inner
                    border.color: "gray"
                    anchors.fill: parent
                    anchors.margins: 1
                    color: _layoutMgr.cellSelected(index) ?
                               "gray" : "white"
                    Drag.active: dragArea.drag.active
                    Drag.hotSpot.x: width/2
                    Drag.hotSpot.y: height/2
                    Text {
                        anchors.centerIn: parent
                        text: index+1
                        font.bold: true
                    }
                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        onPressed: {
                            if (_layoutMgr.cellSelected(index))
                            {
                                highlight.width = inner.width
                                highlight.height = inner.height
                                highlight.x = inner.mapToItem(layoutView, inner.x, inner.y).x
                                highlight.y = inner.mapToItem(layoutView, inner.x, inner.y).y
                                highlight.visible = true
                                dragArea.drag.target = highlight

                                var topLeft = gridView.topLeftPos()
                                var xStart = Math.round((highlight.x-topLeft.x)/gridView.cellWidth)
                                var yStart = Math.round((highlight.y-topLeft.y)/gridView.cellHeight)
                                startIndex = yStart*3+xStart
                            }
                        }
                        onReleased: {
                            highlight.visible = false
                            var topLeft = gridView.topLeftPos()
                            var xEnd = Math.round((highlight.x-topLeft.x)/gridView.cellWidth)
                            var yEnd = Math.round((highlight.y-topLeft.y)/gridView.cellHeight)
                            endIndex = yEnd*3+xEnd
                            _layoutMgr.updateLayout(startIndex, endIndex)
                        }
                    }

                    Component.onCompleted: {
                        if (index === 0)
                        topLeftCell = inner
                    }
                }
            }

            // Current layout changed:
            function onUpdateLayout()
            {
                gridView.model = null
                gridView.model = _layoutMgr.maxImages
            }

            Component.onCompleted: {
                _layoutMgr.layoutIndexChanged.connect(onUpdateLayout)
                _layoutMgr.currentLayoutChanged.connect(onUpdateLayout)
            }
        }
    }
    Rectangle {
        id: highlight
        color: "red"
        visible: false
        z: 1e9
    }
}
