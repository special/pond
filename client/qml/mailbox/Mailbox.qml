import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import "../dates.js" as Dates

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

                    property color textColor: ListView.isCurrentItem ? palette.highlightedText : palette.windowText

                    MouseArea {
                        anchors.fill: parent
                        onClicked: delegate.ListView.view.currentIndex = index
                    }

                    Rectangle {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            leftMargin: 8
                            right: parent.right
                            rightMargin: 8
                        }
                        height: 1
                        visible: !delegate.ListView.isCurrentItem
                        color: Qt.lighter(palette.mid, 1.4)
                    }

                    Column {
                        id: layout
                        spacing: 4
                        anchors {
                            left: parent.left
                            leftMargin: 8
                            right: parent.right
                            rightMargin: 8
                            top: parent.top
                            topMargin: 8
                        }

                        Row {
                            width: parent.width
                            spacing: 8

                            Label {
                                text: model.contactName
                                textFormat: Text.PlainText
                                color: textColor
                                font.bold: true
                            }

                            Label {
                                width: parent.width - x
                                text: Dates.prettyDate(model.sentTime ? model.sentTime : model.createdTime)
                                color: textColor
                                opacity: 0.8
                                elide: Text.ElideRight
                                horizontalAlignment: Qt.AlignRight
                            }
                        }

                        Label {
                            width: parent.width
                            text: model.body.substr(0, 100).replace('\n', ' ')
                            textFormat: Text.PlainText
                            color: textColor
                            opacity: 0.6
                            elide: Text.ElideRight
                            maximumLineCount: 1
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
