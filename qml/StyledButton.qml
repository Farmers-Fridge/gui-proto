import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    style: ButtonStyle {
        label: Component {
            Text {
                text: control.text
                clip: true
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.bold: true
            }
        }
        background: Rectangle {
            implicitWidth: 128
            implicitHeight: 25
            border.width: control.activeFocus ? 2 : 1
            border.color: _colors.ffGray1
            radius: 4
            gradient: Gradient {
                GradientStop { position: 0 ; color: control.pressed ? _colors.ffGreen : _colors.ffGray2 }
                GradientStop { position: 1 ; color: control.pressed ? _colors.ffGray3 : _colors.ffGreen }
            }
        }
    }
}
