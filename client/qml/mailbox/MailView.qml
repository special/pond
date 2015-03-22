import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    id: mailview

    property var mail

    GridLayout {
        width: parent.width
        height: parent.height
        columns: 2

        GridLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            columns: 2

            Label {
                Layout.columnSpan: 2
                text: mail.contactName
                font.bold: true
            }

            Label {
                text: "Created"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
                visible: createdTime.visible
            }
            Label {
                id: createdTime
                text: mail.createdTime
                visible: text.length > 0
            }

            Label {
                text: "Sent"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
                visible: sentTime.visible
            }
            Label {
                id: sentTime
                text: mail.sentTime
                visible: text.length > 0
            }

            Label {
                text: "Acknowledged"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
                visible: ackedTime.visible
            }
            Label {
                id: ackedTime
                text: mail.ackedTime
                visible: text.length > 0
            }

            Label {
                text: "Erase"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
                visible: eraseTime.visible
            }
            Label {
                id: eraseTime
                text: mail.eraseTime
                visible: text.length > 0
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            //Button { text: "Reply" }
            //Button { text: "Ack" }
            //Button { text: "Delete" }
            CheckBox {
                text: "Retain"
                checked: mail.retained
            }
        }

        TextArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 2
            readOnly: true
            textFormat: TextEdit.PlainText

            text: mail.body
        }
    }
}
