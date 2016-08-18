import QtQuick 2.5

Text {
    id: text
    property alias fontFamily: fontLoader.source
    font.family: fontLoader.name
    font.pixelSize: 30
    color: _colors.ffColor1
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideMiddle

    FontLoader {
        id: fontLoader
        source: "../fonts/Grotto Ironic/GrottoIronic-Bold.otf"
    }
}

