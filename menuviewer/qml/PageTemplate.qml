import QtQuick 2.5
import Common 1.0

Page {
    id: pageTemplate

    // Header visible?
    property alias headerVisible: header.visible

    // Footer visible?
    property alias footerVisible: footer.visible

    // Contents:
    property alias contents: contents.children

    // Footer central text:
    property alias footerCentralText: footer.footerCentralText

    // Footer central text visible?
    property alias footerCentralTextVisible: footer.footerCentralTextVisible

    // Footer right text:
    property alias footerRightText: footer.footerRightText

    // Footer right text visible?
    property alias footerRightTextVisible: footer.footerRightTextVisible

    // Handle tab clicked:
    signal tabClicked(string categoryName)

    // Home clicked:
    function onHomeClicked()
    {
        _pageMgr.loadFirstPage()
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

    // Tractor clicked:
    function onTractorClicked()
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
        height: _settings.headerHeight
        anchors.top: parent.top
        onTabClicked: pageTemplate.tabClicked(categoryName)
    }

    // Contents:
    Rectangle {
        id: contents
        anchors.top: header.visible ? header.bottom : parent.top
        anchors.bottom: footer.visible ? footer.top : parent.bottom
        width: parent.width
        color: _colors.ffColor2
    }

    // Footer:
    Footer {
        id: footer
        width: parent.width
        height: parent.height*_settings.footerRatio
        anchors.bottom: parent.bottom
        homeVisible: true
        cartVisible: ((_pageMgr.currentPageId === "MENU_PRESENTATION_PAGE") || (_pageMgr.currentPageId === "MENU_CHECKOUT_PAGE"))
        cartOverLayState: _pageMgr.currentPageId === "MENU_CHECKOUT_PAGE" ? "requestPay" : "cartCount"
        emailVisible: _pageMgr.currentPageId === "MENU_CHECKOUT_PAGE"
        couponVisible: _pageMgr.currentPageId === "MENU_CHECKOUT_PAGE"
        tractorVisible: _pageMgr.currentPageId === "MENU_CHECKOUT_PAGE"
        pigVisible: (_pageMgr.currentPageId !== "MENU_PRESENTATION_PAGE") ||
            ((_pageMgr.currentPageId === "MENU_PRESENTATION_PAGE") && (_viewMode === "pathview"))
        bottomAreaSource: "qrc:/assets/ico-primary-darkbar.png"
        onHomeClicked: pageTemplate.onHomeClicked()
        onEmailClicked: pageTemplate.onEmailClicked()
        onCouponClicked: pageTemplate.onCouponClicked()
        onTractorClicked: pageTemplate.onTractorClicked()
        onPigClicked: pageTemplate.onPigClicked()
        onCartClicked: pageTemplate.onCartClicked()
    }
}
