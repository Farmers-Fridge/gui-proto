import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import Common 1.0
import KeyBoard 1.0

Item {
    id: stockItem
    property double innerRectRatio: .95
    property int userActualPar: actualPar
    property bool highlighted: false
    focus: true

    // Ok clicked:
    function onOKClicked(keyId)
    {
        // Clear previous par values:
        while (previousParValues.length > 0)
            previousParValues.pop()

        // Store previous par values:
        for (var i=0; i<xmlColumnModel.count; i++)
            previousParValues.push(xmlColumnModel.get(i).actualPar)

        // Set user actual par:
        if (userActualPar !== keyId)
        {
            // Set application busy:
            _appIsBusy = false

            // Set user acual par:
            userActualPar = keyId

            // Run command:
            _updateRestockExceptionCommand.row = rowNumber
            _updateRestockExceptionCommand.column = columnNumber
            _updateRestockExceptionCommand.theoExpired = theoExpired
            _updateRestockExceptionCommand.theoAdds = theoAdds
            _updateRestockExceptionCommand.userActualPar = userActualPar
            _updateRestockExceptionCommand.theoPar = theoPar

            // Connect:
            _updateRestockExceptionCommand.cmdSuccess.connect(xmlColumnModel.onUpdateRestockExceptionCommandSucces)
            _updateRestockExceptionCommand.cmdError.connect(xmlColumnModel.onUpdateRestockExceptionCommandError)

            // Execute:
            _updateRestockExceptionCommand.execute()
        }

        stockNumericKeyPad.state = ""
    }

    Rectangle {
        id: inner
        color: _colors.ffColor13
        width: parent.width*innerRectRatio
        height: parent.height*innerRectRatio

        radius: 8
        border.width: 3
        border.color: highlighted ? _colors.ffColor12 : _colors.ffColor3
        anchors.centerIn: parent

        // Title:
        StandardText {
            id: menuTitle
            width: parent.width-4
            font.pixelSize: 16
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            text: vendItemName
        }

        // Product:
        Image {
            id: product
            anchors.top: menuTitle.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: Utils.urlPublicStatic(_appData.serverInfo.urlForStock, iconUrl)
            width: Math.min(inner.height * .7, inner.width) * .85
            height: Math.min(inner.height * .7, inner.width) * .85
            asynchronous: true
        }

        // Stock manager:
        Item {
            id: stockMgr
            width: parent.width
            height: 48
            anchors.bottom: orders.top
            anchors.bottomMargin: itemSpacing/2

            Item {
                id: part1
                width: 128
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                // Actual par:
                Text {
                    id: actualParText
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    color: _colors.ffColor14
                    font.bold: true
                    text: userActualPar
                }
            }
        }

        // Orders:
        Item {
            id: orders
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 32
            StandardText {
                id: pullTextBox
                font.pixelSize: parent.height *.75
                color: _colors.ffColor15
                text: theoExpired
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
            }
            StandardText {
                font.pixelSize: parent.height *.75
                color: _colors.ffColor3
                text: actualAdd
                anchors.centerIn: parent
            }
            StandardText {
                font.pixelSize: parent.height
                color: (previousParValues.length > 0) ? (userActualPar > previousParValues[index] ? _colors.ffColor3 : _colors.ffColor15) : _colors.ffColor1
                text: actualPar
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // Current stock item changed:
    function onCurrentStockItemChanged()
    {
        // Don't use !==
        if (stockItem)
            highlighted = ((_currentStockItemRow == rowNumber) && (_currentStockItemCol == columnNumber))
    }

    // Handle hover events:
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: mainApplication.setCurrentStockItem(rowNumber, columnNumber)
        onClicked: {
            stockNumericKeyPad.theoPar = theoPar
            stockNumericKeyPad.currentKey = actualPar
            stockNumericKeyPad.invoker = stockItem
            stockNumericKeyPad.state = "on"
        }
    }

    Component.onCompleted: {
        mainApplication.currentStockItemChanged.connect(onCurrentStockItemChanged)
    }
}
