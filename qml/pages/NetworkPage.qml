import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import ".."
import "../script/Utils.js" as Utils

CustomPage {
    pageId: "_networkpage_"
    idleTime: _timeSettings.pageIdleTime

    // Time out:
    function onIdleTimeOut()
    {
        mainWindow.logMessage("NETWORKPAGE::LOADPREVIOUS")
        mainApplication.loadPreviousPage()
    }

    // Host model:
    CustomXmlListModel {
        id: xmlHostModel
        source: Utils.staticNoCacheOf(_appData.urlPublicRootValue, "/hosts.xml")
        query: "/hosts/item"

        XmlRole { name: "name"; query: "name/string()"; isKey: true }
        XmlRole { name: "url"; query: "url/string()"; isKey: true }
    }

    // Top bar:
    topBar: Item {
        anchors.fill: parent
        RowLayout {
            Layout.preferredWidth: parent.width
            spacing: 16
            height: parent.height
            anchors.centerIn: parent
            StyledButton {
                id: exist
                text: qsTr("BACK")
                onClicked: mainApplication.loadPreviousPage()
            }
        }
    }

    // Contents:
    contents: Item {
        anchors.fill: parent

        // Icon:
        Image {
            id: logo
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/qml/images/ico-logo.png"
        }

        // Title:
        CommonText {
            text: qsTr("Please select target network, or enter it manually")
            anchors.top: logo.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 32
        }

        // Background:
        Rectangle {
            id: background
            color: _colors.ffLightGray
            opacity: .5
            border.color: _colors.ffBlack
            border.width: 3
            width: parent.width-32
            height: parent.height*3/4
            anchors.centerIn: parent
        }

        // Text input:
        TextField {
            id: ipTextInput
            anchors.top: background.bottom
            anchors.topMargin: 8
            anchors.left: background.left
            anchors.right: background.right
            height: 48
            maximumLength: 15
            font.pixelSize: 18
            onTextChanged: _controller.currentNetworkIP = text

            // Return pressed:
            onAccepted: {
                _controller.currentNetworkIP = url
                _pageMgr.setupStockPage()
                mainApplication.loadPage("_stockpage_")
            }

            // OK:
            ImageButton {
                id: okButton
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 48
                source: "qrc:/qml/images/ico-ok.png"
                onClicked: {
                    _controller.currentNetworkIP = url
                    _pageMgr.setupStockPage()
                    mainApplication.loadPage("_stockpage_")
                }
            }

            Component.onCompleted: ipTextInput.text = _controller.currentNetworkIP
        }

        // Network gridview:
        GridView {
            id: gridView
            anchors.fill: background
            anchors.margins: 8
            cellWidth: width/3
            cellHeight: width/3
            model: xmlHostModel
            clip: true
            property int currentIndex: -1
            delegate:  Item {
                width: gridView.cellWidth
                height: gridView.cellHeight
                Rectangle {
                    id: rect
                    anchors.fill: parent
                    anchors.margins: 8
                    color: _colors.ffLightGray
                    border.color: index == gridView.currentIndex ? _colors.ffOrange : _colors.ffGreen
                    border.width: 8
                    radius: 8
                    CommonText {
                        anchors.centerIn: parent
                        width: parent.width-16
                        horizontalAlignment: Text.AlignHCenter
                        text: name
                        font.pixelSize: 18
                    }
                    states: State {
                        name: "pressed"
                        when: mouseArea.pressed
                        PropertyChanges {
                            target: rect
                            scale: .95
                        }
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: gridView.currentIndex = index
                    onClicked: {
                        _controller.currentNetworkIP = url
                        _pageMgr.setupStockPage()
                        mainApplication.loadPage("_stockpage_")
                    }
                }
            }
        }

        // Digital clock:
        DigitalClock {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
