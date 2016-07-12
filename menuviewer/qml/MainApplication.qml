import QtQuick 2.5
import QtQuick.XmlListModel 2.0
import Common 1.0
import KeyBoard 1.0
import Commands 1.0

Item {
    // Show private keypad:
    signal showPrivateKeyPad()

    // Load path view:
    signal loadPathView()

    // Load grid view:
    signal loadGridView()

    // Set menu page mode:
    signal setMenuPageMode()

    // Navigate left:
    signal navigateLeft()

    // Navigate right:
    signal navigateRight()

    // Add current item to cart:
    signal addCurrentItemToCart()

    // Show nutritional info:
    signal showNutritionalInfo()

    // Show keypad:
    function onShowPrivateKeyPad()
    {
        privateNumericKeyPad.state = "on"
    }

    // Add to cart command:
    AddToCartCommand {
        id: _addToCartCommand
        onAddItem: _controller.addItem(vendItemName, icon, nutrition, category, price)
    }

    // Page mgr:
    PageMgr {
        id: pageMgr
        anchors.fill: parent
        pages: _appData.pages
        enabled: privateNumericKeyPad.state === ""
    }

    // XML version model:
    CustomXmlListModel {
        id: categoryModel
        source: Utils.urlPlay(_appData.currentIP, _appData.categorySource)
        query: _appData.categoryQuery

        XmlRole { name: "categoryName"; query: "categoryName/string()"; isKey: true }
        XmlRole { name: "icon"; query: "icon/string()"; isKey: true }
        XmlRole { name: "header"; query: "header/string()"; isKey: true }

        onStatusChanged: {
            // Load main application:
            if (status !== XmlListModel.Loading)
            {
                // Error:
                if (status === XmlListModel.Error)
                {
                    // Log:
                    console.log("Can't load: " + source)
                }
                else
                // Model ready:
                if (status === XmlListModel.Ready)
                {
                    // Set current category name:
                    _controller.currentCategory = categoryModel.get(0).categoryName

                    // Set category model:
                    _categoryModel = categoryModel

                    // Log:
                    console.log(source + " loaded successfully")
                }
            }
        }
    }

    // Numeric keypad:
    NumericKeyPad {
        id: privateNumericKeyPad
        opacity: 0
        visible: opacity > 0
        anchors.centerIn: parent
        z: 1e9
        // OK clicked (TO DO):
        onOkClicked: {
            // User entered exit code:
            if (enteredText === _appData.exitCode)
                Qt.quit()
            // (TO DO)
            /*
            else
            if (enteredText === _appData.tabletGuiCode)
                mainApplication.loadPage("_networkpage_")
            */
            privateNumericKeyPad.state = ""
        }
        // Cancel clicked (TO DO):
        onCancelClicked: {
            privateNumericKeyPad.state = ""
        }
        onStateChanged: privateNumericKeyPad.enteredText = ""
        states: State {
            name: "on"
            PropertyChanges {
                target: privateNumericKeyPad
                opacity: 1
            }
        }
        Behavior on opacity {
            NumberAnimation {duration: 500}
        }
    }

    // Reserved area:
    ReservedArea {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: (_settings.footerRatio/2)*parent.height
        width: height
        z: 1e9
        onReservedAreaClicked: showPrivateKeyPad()
    }

    Component.onCompleted: {
        mainApplication.showPrivateKeyPad.connect(onShowPrivateKeyPad)
    }
}

