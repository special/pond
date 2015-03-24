import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ToolBar {
    id: toolBar

    property int messageToolsPosition
    property var messageToolsTarget: null

    RowLayout {
        id: globalTools
        IconToolButton { icon: "\uf234" } // Add Contact
        IconToolButton { icon: "\uf1d8" } // Compose
        IconToolButton { icon: "\uf0ad" } // Settings
    }

    RowLayout {
        x: Math.max(messageToolsPosition - spacing, globalTools.x + globalTools.width + spacing)
        enabled: messageToolsTarget != null

        IconToolButton { // Reply
            icon: "\uf112"
        }
        IconToolButton { // Acknowledge
            icon: "\uf00c"
            enabled: parent.enabled && messageToolsTarget.receivedTime && !messageToolsTarget.acked
        }
        IconToolButton { // Delete
            icon: "\uf1f8"
        }
    }
}

