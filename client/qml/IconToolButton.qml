import QtQuick 2.0
import QtQuick.Controls 1.0

ToolButton {
    id: button
    property string icon

    Label {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: icon
        font.family: iconFont.name
        color: button.enabled ? (button.pressed ? "white" : "black") : "#666666"
        font.pixelSize: 20
    }
}
