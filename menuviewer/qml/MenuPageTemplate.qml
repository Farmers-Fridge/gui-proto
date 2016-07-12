import QtQuick 2.5
import Common 1.0

Page {
    id: menuPageTemplate
    property alias topContents: topArea.children
    property alias bottomContents: bottomArea.children
    property alias homeVisible: footer.homeVisible
    property alias pigVisible: footer.pigVisible
    property alias cartVisible: footer.cartVisible
    signal tabClicked()

    // Home clicked:
    function onHomeClicked()
    {
        pageMgr.loadFirstPage()
    }

    // Pig clicked:
    function onPigClicked()
    {
        // Base impl does nothing:
    }

    // Cart clicked:
    function onCartClicked()
    {
        // Base impl does nothing:
    }

    // Header:
    Header {
        id: header
        width: parent.width
        height: parent.height*_settings.headerRatio
        anchors.top: parent.top
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        onTabClicked: menuPageTemplate.tabClicked()
    }

    // Contents:
    Item {
        id: contents
        anchors.top: header.bottom
        anchors.bottom: footer.top
        width: parent.width

        // Top area:
        Rectangle {
            id: topArea
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: bottomArea.top
            color: _settings.bkgColor
        }

        // Bottom area:
        Rectangle {
            id: bottomArea
            width: parent.width
            height: parent.height*.25
            anchors.bottom: parent.bottom
            border.color: _settings.ffGreen
            color: _settings.bkgColor
        }
    }

    // Header:
    Footer {
        id: footer
        width: parent.width
        height: parent.height*_settings.footerRatio
        anchors.bottom: parent.bottom
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        onHomeClicked: menuPageTemplate.onHomeClicked()
        onPigClicked: menuPageTemplate.onPigClicked()
        onCartClicked: menuPageTemplate.onCartClicked()
    }
}
