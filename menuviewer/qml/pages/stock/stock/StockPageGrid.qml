import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import Common 1.0

ScrollView {
    anchors.fill: parent

    style: ScrollViewStyle {
        handle: Item {
            implicitWidth: 14
            implicitHeight: 26
            Rectangle {
                color: _colors.ffColor3
                anchors.fill: parent
                anchors.topMargin: 6
                anchors.bottomMargin: 6
            }
        }
        scrollBarBackground: Item {
            implicitWidth: 14
            implicitHeight: 26
        }
    }

    ListView {
        id: stockGridBlock
        anchors.fill: parent
        property int delegateHeight: 400
        verticalLayoutDirection: ListView.TopToBottom
        clip: true
        spacing: 5
        snapMode: ListView.SnapToItem
        interactive: true
        cacheBuffer: xmlRowModel.count*delegateHeight
        model: xmlRowModel

        delegate: Component {
            id: stockRowDelegate
            StockPageRow {
                height: stockGridBlock.delegateHeight
                width: stockGridBlock.width
                rowNumber: Utils.objValid(xmlRowModel.get(index)) ? xmlRowModel.get(index).rowNumber : -1
            }
        }
    }
}
