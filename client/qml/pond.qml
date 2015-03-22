import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width: 320
    height: 200

    data: [
        SystemPalette { id: palette }
    ]

    toolBar: ToolBar {
        RowLayout {
            ToolButton { text: "Add contact" }
            ToolButton { text: "Compose" }
            ToolButton { text: "Activity log" }
            ToolButton { text: "State" }
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
