import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width: 960
    height: 500

    data: [
        SystemPalette { id: palette },
        GoModel { id: inboxMessages; objectName: "inboxMessages" },
        GoModel { id: outboxMessages; objectName: "outboxMessages" },
        GoModel { id: draftMessages; objectName: "draftMessages" },
        FontLoader { id: iconFont; source: "./FontAwesome.otf" }
    ]

    toolBar: ToolBar {
        id: toolBar

        RowLayout {
            IconToolButton { icon: "\uf234" } // Add Contact
            IconToolButton { icon: "\uf1d8" } // Compose
            IconToolButton { icon: "\uf0ad" } // Settings
        }
    }

    SplitView {
        anchors.fill: parent

        SideBar {
            id: sidebar
            width: 150
            Layout.minimumWidth: 100
        }

        PageView {
            id: other
            currentPage: sidebar.currentItem
        }
    }
}
