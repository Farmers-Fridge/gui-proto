import QtQuick 2.4

Text {
    font.pixelSize: _settings.pixelSize
    font.family: _settings.fontFamily
    color: _settings.textColor
    font.bold: true
    wrapMode: Text.WordWrap
}

