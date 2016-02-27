import QtQuick 2.4
import "script/Utils.js" as Utils

// Category view:
Row {
    Repeater {
        model: _categoryModel
        width: parent.width
        height: itemIcon.paintedHeight

        // Item icon:
        ImageButton {
            id: itemIcon
            width: parent.width/_categoryModel.count
            fillMode: Image.PreserveAspectFit
            anchors.top: parent.top
            source: Utils.urlPublicStatic(icon)
            onClicked: _controller.currentCategory = categoryName
        }
    }
}