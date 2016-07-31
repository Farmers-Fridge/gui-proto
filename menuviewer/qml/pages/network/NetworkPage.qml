import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import Common 1.0
import "../.."

SimplePageTemplate {
    // Host model:
    CustomXmlListModel {
        id: xmlHostModel
        source: Utils.staticNoCacheOf(_appData.urlPublicRootValue, "/hosts.xml")
        query: "/hosts/item"

        XmlRole { name: "name"; query: "name/string()"; isKey: true }
        XmlRole { name: "url"; query: "url/string()"; isKey: true }

        onStatusChanged: _appIsBusy = (status === XmlListModel.Loading)
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
            source: "qrc:/assets/ico-logo.png"
        }

        // Title:
        CommonText {
            id: title
            text: qsTr("Please select target network, or enter it manually")
            anchors.top: logo.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 32
        }

        // Background:
        Rectangle {
            id: background
            color: _settings.ffLightGray
            opacity: .5
            border.color: _settings.ffBlack
            border.width: 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title.bottom
            anchors.bottom: ipTextInput.top
            anchors.margins: 24
        }

        // Text input:
        TextField {
            id: ipTextInput
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: background.left
            anchors.right: background.right
            height: 48
            maximumLength: 15
            font.pixelSize: 18
            onTextChanged: _controller.currentNetworkIP = text

            // Return pressed:
            onAccepted: {
                _controller.currentNetworkIP = url
                pageMgr.loadPage("STOCK_PAGE")
            }

            // OK:
            ImageButton {
                id: okButton
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 48
                source: "qrc:/assets/ico-ok.png"
                onClicked: {
                    _controller.currentNetworkIP = url
                    //pageMgr.setupStockPage()
                    pageMgr.loadPage("STOCK_PAGE")
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
                    color: _settings.ffLightGray
                    border.color: index == gridView.currentIndex ? _settings.ffOrange : _settings.ffGreen
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
                        pageMgr.loadPage("STOCK_PAGE")
                    }
                }
            }
        }
    }
}
