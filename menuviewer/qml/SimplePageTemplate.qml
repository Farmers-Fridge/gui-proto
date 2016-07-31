import QtQuick 2.5
import Common 1.0

Page {
    id: simplePageTemplate
    property alias contents: contents.children
    property alias footer: footer.children

    // Home clicked:
    function onHomeClicked()
    {
        pageMgr.loadFirstPage()
    }

    // Pig clicked:
    function onPigClicked()
    {
        pageMgr.loadPreviousPage()
    }

    // Contents:
    Item {
        id: contents
        anchors.top: parent.top
        anchors.bottom: footer.top
        width: parent.width
    }

    // Header:
    Footer {
        id: footer
        width: parent.width
        height: parent.height*_settings.footerRatio
        anchors.bottom: parent.bottom
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        homeVisible: true
        onHomeClicked: simplePageTemplate.onHomeClicked()
        pigVisible: true
        onPigClicked: simplePageTemplate.onPigClicked()
        cartVisible: false

        // Digital clock:
        DigitalClock {
            anchors.top: footer.bottomAreaContainer.top
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
