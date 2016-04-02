import QtQuick 2.5
import "script/Utils.js" as Utils

GridView {
    id: itemView
    property int gridViewIndex: 0
    signal gridImageClicked(int selectedIndex)

    // Delegate:
    delegate: Item {
        id: imageDelegate
        visible: vendItemName !== ""
        width: itemView.cellWidth
        height: itemView.cellHeight

        // Image loading background
        Rectangle {
            id: imageLoadingBkg
            color: "white"
            anchors.centerIn: parent
            antialiasing: true
            width: height
            height: itemView.width/3
            visible: originalImage.status !== Image.Ready
            Rectangle {
                color: _settings.green
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Busy indicator:
        BusyIndicator {
            anchors.centerIn: parent
            on: originalImage.status !== Image.Ready
            visible: on
        }

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            source: icon !== "" ? Utils.urlPublicStatic(icon) : ""
            cache: true
            fillMode: Image.PreserveAspectFit
            width: height
            height: itemView.width/3
            anchors.centerIn: parent

            MouseArea {
                anchors.fill: parent
                onClicked: gridImageClicked(index-1)
            }
        }
    }

    // Model ready:
    function onModelReady()
    {
        var nItems = categoryListModel.count
        if (nItems === 1)
        {
            cellWidth = itemView.width
            cellHeight = itemView.height
        }
        else
        if (nItems === 2)
        {
            cellWidth = itemView.width/2
            cellHeight = itemView.height
        }
        else
        if (nItems === 3)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/1
        }
        else
        if (nItems === 4)
        {
            cellWidth = itemView.width/2
            cellHeight = itemView.height/2
        }
        else
        if (nItems === 5)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/2
        }
        else
        if (nItems === 6)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/2
        }
        else
        if (nItems > 6)
        {
            cellWidth = itemView.width/3
            cellHeight = itemView.height/3
        }

        console.log("CELLWIDTH/CELLHEIGHT: ", nItems, cellWidth, cellHeight)
    }
}
