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
            color: _colors.ffWhite
            anchors.centerIn: parent
            antialiasing: true
            width: height
            height: itemView.width/3
            visible: originalImage.status !== Image.Ready
            Rectangle {
                color: _colors.ffDarkGreen
                antialiasing: true
                anchors { fill: parent; margins: 3 }
            }
        }

        // Original image:
        Image {
            id: originalImage
            antialiasing: true
            source: Utils.urlPublicStatic(_appData.urlPublicRootValue, icon)
            cache: true
            fillMode: Image.PreserveAspectFit
            width: height
            height: itemView.width/3
            anchors.centerIn: parent

            // Busy indicator:
            BusyIndicator {
                id: busyIndicator
                anchors.centerIn: parent
                on: originalImage.status === Image.Loading
                visible: on
            }

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
    }
}
