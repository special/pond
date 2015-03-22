import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    color: palette.base
    anchors.fill: parent

    property var pageData

    data: [
        ListModel {
            id: model
            ListElement { body: "message"; time: "March 15 20:20"; from: "First Guy" }
            ListElement { body: "Message"; time: "March 14 1:39"; from: "Second Guy" }
        }
    ]

    SplitView {
        anchors.fill: parent

        ScrollView {
            Layout.fillWidth: false
            Layout.minimumWidth: 200
            width: 200

            ListView {
                id: mailsView
                Layout.minimumWidth: 200

                model: pageData.subview == "inbox" ? inboxMessages : model
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
                            text: model.from
                            color: delegate.ListView.isCurrentItem ? palette.highlightedText : palette.windowText
                        }
                        Label {
                            text: model.time
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
                    mail: mailsView.currentIndex >= 0 ? mailsView.model.get(mailsView.currentIndex) : null
                    visible: mail !== null
                }
            }
        }
    }
}
