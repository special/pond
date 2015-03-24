import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    id: mailbox
    color: palette.base
    anchors.fill: parent

    property var pageData
    property var model: {
        switch (pageData.subview) {
            case "inbox": return inboxMessages
            case "outbox": return outboxMessages
            case "drafts": return draftMessages
            default: return 0
        }
    }

    SplitView {
        anchors.fill: parent

        ScrollView {
            Layout.fillWidth: false
            Layout.minimumWidth: 200
            width: 200

            ListView {
                id: mailsView
                Layout.minimumWidth: 200

                model: mailbox.model
                currentIndex: -1

                delegate: Rectangle {
                    id: delegate
                    width: parent.width
                    height: layout.height + 16
                    color: ListView.isCurrentItem ? palette.highlight : palette.base

                    MouseArea {
                        anchors.fill: parent
                        onClicked: delegate.ListView.view.currentIndex = index
                    }

                    ColumnLayout {
                        id: layout
                        width: parent.width - 16
                        x: 8
                        y: 8
                        Label {
                            text: model.contactName
                            color: delegate.ListView.isCurrentItem ? palette.highlightedText : palette.windowText
                        }
                        Label {
                            text: model.sentTime ? model.sentTime : model.createdTime
                            color: "#666666"
                        }
                    }
                }
            }
        }

        Rectangle {
            id: mailView
            Layout.fillWidth: true
            color: palette.window

            Loader {
                anchors {
                    fill: parent
                    leftMargin: 16
                    rightMargin: 16
                    topMargin: 8
                    bottomMargin: 8
                }

                sourceComponent: mailViewComponent
                active: mailsView.currentIndex >= 0
            }

            Component {
                id: mailViewComponent

                MailView {
                    mail: mailsView.currentIndex >= 0 ? mailbox.model.get(mailsView.currentIndex) : null
                    visible: mail !== null
                }
            }

            // Monitor for global position changes
            Component.onCompleted: {
                var p = mailView
                while (p) {
                    p.xChanged.connect(updatePosition)
                    p = p.parent
                }
                updatePosition()
            }

            onVisibleChanged: updatePosition()
            function updatePosition() {
                if (visible)
                    toolBar.messageToolsPosition = mapToItem(toolBar, 0, 0).x
            }
        }
    }
}
