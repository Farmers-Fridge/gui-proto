import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "script/Utils.js" as Utils

Item {
    id: stockItem
    property double innerRectRatio: .95
    property int userActualPar: actualPar
    property alias labelOn: itemStatus.labelOn
    property alias labelOff: itemStatus.labelOff
    property bool kitchenShort: true
    property bool machineShort: false
    property bool highlighted: false
    focus: true
    Rectangle {
        id: inner
        color: "transparent"
        width: parent.width*innerRectRatio
        height: parent.height*innerRectRatio

        radius: 8
        border.width: 3
        border.color: highlighted ? _colors.ffOrange : _colors.ffGreen
        anchors.centerIn: parent

        // Title:
        CommonText {
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
            source: Utils.urlPublicStatic(_appData.urlPublicRootValue, iconUrl)
            width: Math.min(inner.height * .7, inner.width) * .85
            height: Math.min(inner.height * .7, inner.width) * .85
        }

        // Stock manager:
        Item {
            id: stockMgr
            width: parent.width
            height: 48
            anchors.bottom: itemStatus.top
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
                    color: "brown"
                    font.bold: true
                    text: userActualPar
                }
            }
        }

        // Item status:
        ToggleButton {
            id: itemStatus
            anchors.bottom: orders.top
            anchors.bottomMargin: itemSpacing
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-8
            height: itemSpacing*2
            visible: userActualPar != theoPar
            onToggled: {
                kitchenShort = active
                machineShort = !active
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
            CommonText {
                id: pullTextBox
                font.pixelSize: parent.height *.75
                color: _colors.ffPull
                text: theoExpired
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
            }
            CommonText {
                font.pixelSize: parent.height *.75
                color: _colors.ffStock
                text: actualAdd
                anchors.centerIn: parent
            }
            CommonText {
                font.pixelSize: parent.height
                color: (actualPar == theoPar) ? _colors.ffPar : _colors.ffException
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
        // Don't use ==!
        if (stockItem !== undefined)
            highlighted = ((_currentStockItemRow == rowNumber) && (_currentStockItemCol == columnNumber))
    }

    // Ok clicked:
    function onStockKeyPadEnterKeyClicked(keyId)
    {
        // Set user actual par:
        if (userActualPar !== keyId)
        {
            userActualPar = keyId

            // Run command:
            _updateRestockExceptionCommand.row = rowNumber
            _updateRestockExceptionCommand.column = columnNumber
            _updateRestockExceptionCommand.theoExpired = theoExpired
            _updateRestockExceptionCommand.theoAdds = theoAdds
            _updateRestockExceptionCommand.userActualPar = userActualPar
            _updateRestockExceptionCommand.theoPar = theoPar
            _updateRestockExceptionCommand.kitchenShort = kitchenShort
            _updateRestockExceptionCommand.machineShort = machineShort

            // Connect:
            _updateRestockExceptionCommand.cmdSuccess.connect(xmlColumnModel.onUpdateRestockExceptionCommandSucces)
            _updateRestockExceptionCommand.cmdError.connect(xmlColumnModel.onUpdateRestockExceptionCommandError)

            // Execute:
            _updateRestockExceptionCommand.execute()
        }
        mainApplication.hideStockKeyPad()

        // Disconnect:
        mainApplication.stockKeyPadEnterKeyClicked.disconnect(onStockKeyPadEnterKeyClicked)
        mainApplication.stockKeyPadCancelKeyClicked.disconnect(onStockKeyPadCancelKeyClicked)
    }

    // Ok clicked:
    function onStockKeyPadCancelKeyClicked()
    {
        mainApplication.hideStockKeyPad()

        /// Disconnect:
        mainApplication.stockKeyPadEnterKeyClicked.disconnect(onStockKeyPadEnterKeyClicked)
        mainApplication.stockKeyPadCancelKeyClicked.disconnect(onStockKeyPadCancelKeyClicked)
    }

    // Handle hover events:
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: mainApplication.setCurrentStockItem(rowNumber, columnNumber)
        onClicked: {
            mainApplication.stockKeyPadEnterKeyClicked.connect(onStockKeyPadEnterKeyClicked)
            mainApplication.stockKeyPadCancelKeyClicked.connect(onStockKeyPadCancelKeyClicked)
            mainApplication.showStockKeyPad(theoPar, actualPar)
        }
    }

    Component.onCompleted: {
        mainApplication.currentStockItemChanged.connect(onCurrentStockItemChanged)
    }
}
