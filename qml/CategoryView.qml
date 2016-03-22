import QtQuick 2.4
import "script/Utils.js" as Utils

// Category view:
Row {
    id: row
    Repeater {
        model: _categoryModel

        Item {
            width: row.width/_categoryModel.count
            height: row.height

            // Item icon:
            ImageButton {
                id: itemIcon
                anchors.fill: parent
                anchors.top: parent.top
                source: Utils.urlPublicStatic(icon)
                onClicked: {
                    _controller.currentCategory = categoryName
                    mainApplication.updateBrowserView(index)
                    mainApplication.goBackToMainPage()
                }
            }
        }
    }
}
