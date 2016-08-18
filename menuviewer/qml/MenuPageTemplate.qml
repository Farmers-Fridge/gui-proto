import QtQuick 2.5
import Common 1.0

Page {
    id: menuPageTemplate
    property alias contents: contents.children
    property alias homeVisible: footer.homeVisible
    property alias emailVisible: footer.emailVisible
    property alias couponVisible: footer.couponVisible
    property alias pigVisible: footer.pigVisible
    property alias cartVisible: footer.cartVisible
    signal tabClicked()

    // Home clicked:
    function onHomeClicked()
    {
        pageMgr.loadFirstPage()
    }

    // Email clicked:
    function onEmailClicked()
    {
        // Base impl does nothing
    }

    // Coupon clicked:
    function onCouponClicked()
    {
        // Base impl does nothing
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
    Rectangle {
        id: contents
        anchors.top: header.bottom
        anchors.bottom: footer.top
        width: parent.width
        color: _colors.ffColor2
    }

    // Header:
    Footer {
        id: footer
        width: parent.width
        height: parent.height*_settings.footerRatio
        anchors.bottom: parent.bottom
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        onHomeClicked: menuPageTemplate.onHomeClicked()
        onEmailClicked: menuPageTemplate.onEmailClicked()
        onCouponClicked: menuPageTemplate.onCouponClicked()
        onPigClicked: menuPageTemplate.onPigClicked()
        onCartClicked: menuPageTemplate.onCartClicked()
    }
}
