import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    id: mailview

    property var mail

    GridLayout {
        width: parent.width
        columns: 2

        GridLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            columns: 2

            Label {
                Layout.columnSpan: 2
                text: mail.from
                font.bold: true
            }

            Label {
                text: "Sent"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
            }
            Label {
                text: mail.time
            }

            Label {
                text: "Erase"
                color: "#666666"
                font.capitalization: Font.SmallCaps
                Layout.alignment: Qt.AlignRight
            }
            Label {
                text: mail.time
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Button { text: "Reply" }
            Button { text: "Ack" }
            Button { text: "Delete" }
            CheckBox { text: "Retain" }
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
