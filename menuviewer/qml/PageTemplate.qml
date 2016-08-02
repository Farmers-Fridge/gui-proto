import QtQuick 2.5
import Common 1.0

Page {
    id: menuPageTemplate

    // Header visible?
    property alias headerVisible: header.visible

    // Footer visible?
    property alias footerVisibile: footer.visible

    // Contents:
    property alias contents: contents.children

    // Handle tab clicked:
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
        anchors.top: header.visible ? header.bottom : parent.top
        anchors.bottom: footer.visible ? footer.top : parent.bottom
        width: parent.width
        color: _settings.ffIvoryLight
    }

    // Header:
    Footer {
        id: footer
        width: parent.width
        height: parent.height*_settings.footerRatio
        anchors.bottom: parent.bottom
        homeVisible: pageMgr.currentPageId !== "MENU_PAGE"
        cartVisible: pageMgr.currentPageId === "MENU_PAGE"
        emailVisible: pageMgr.currentPageId === "CHECKOUT_PAGE"
        couponVisible: pageMgr.currentPageId === "CHECKOUT_PAGE"
        pigVisible: (pageMgr.currentPageId !== "MENU_PAGE") ||
            ((pageMgr.currentPageId === "MENU_PAGE") && (_viewMode === "pathview"))
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        onHomeClicked: menuPageTemplate.onHomeClicked()
        onEmailClicked: menuPageTemplate.onEmailClicked()
        onCouponClicked: menuPageTemplate.onCouponClicked()
        onPigClicked: menuPageTemplate.onPigClicked()
        onCartClicked: menuPageTemplate.onCartClicked()
    }
}
