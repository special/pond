import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    id: sidebar
    Layout.fillHeight: true

    property var currentItem: view.currentIndex >= 0 ? model.get(view.currentIndex) : null

    ListModel {
        id: model

        ListElement { text: qsTr("Inbox"); icon: "\uf01c"; source: "mailbox/Mailbox.qml"; subview: "inbox" }
        ListElement { text: qsTr("Sent"); icon: "\uf1d9"; source: "mailbox/Mailbox.qml"; subview: "outbox" }
        ListElement { text: qsTr("Drafts"); icon: "\uf15b"; source: "mailbox/Mailbox.qml"; subview: "drafts" }
        ListElement { text: qsTr("Contacts"); icon: "\uf0c0"; source: "views/Contacts.qml" }
    }

    ScrollView {
        anchors.fill: parent
        ListView {
            id: view
            model: model

            delegate: Rectangle {
                id: delegate
                width: parent.width
                height: layout.height + 16
                color: ListView.isCurrentItem ? palette.highlight : palette.window

                MouseArea {
                    anchors.fill: parent
                    onClicked: view.currentIndex = model.index
                }

                RowLayout {
                    id: layout
                    width: parent.width - 16
                    x: 8
                    y: 8

                    Label {
                        Layout.preferredWidth: 16
                        horizontalAlignment: Text.AlignHCenter
                        text: model.icon
                        font.family: iconFont.name
                        color: text.color
                    }

                    Label {
                        id: text
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        text: model.text
                        color: delegate.ListView.isCurrentItem ? palette.highlightedText : palette.windowText
                    }
                }
            }
        }
    }
}

