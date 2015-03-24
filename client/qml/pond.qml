import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width: 960
    height: 500

    property bool finishedLoading
    onFinishedLoadingChanged: {
        if (unlockLoader.active)
            unlockLoader.active = false
    }

    function showKeyPrompt(handler) {
        unlockLoader.active = true
        unlockLoader.item.handler = handler
    }

    data: [
        SystemPalette { id: palette },
        GoModel { id: inboxMessages; objectName: "inboxMessages" },
        GoModel { id: outboxMessages; objectName: "outboxMessages" },
        GoModel { id: draftMessages; objectName: "draftMessages" },
        FontLoader { id: iconFont; source: "./FontAwesome.otf" }
    ]

    toolBar: PondToolBar {
        id: toolBar
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

    Loader {
        id: unlockLoader
        anchors.fill: parent
        active: false
        sourceComponent: UnlockScreen {
            id: unlockScreen
            z: 100
            focus: true

            Component.onCompleted: unlockScreen.forceActiveFocus()
        }
    }
}
