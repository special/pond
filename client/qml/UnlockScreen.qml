import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

FocusScope {
    id: unlockScreen

    property var handler
    property int attempts

    Rectangle {
        anchors.fill: parent
        color: palette.window
    }

    Label {
        id: lockIcon
        anchors {
            bottom: passwordField.top
            bottomMargin: 8
            horizontalCenter: passwordField.horizontalCenter
        }

        text: "\uf023"
        font.family: iconFont.name
        font.pixelSize: 48
    }

    TextField {
        id: passwordField
        anchors.centerIn: parent
        width: unlockScreen.width * 0.4
        height: 36
        focus: true

        font.pixelSize: 24
        echoMode: TextInput.Password
        horizontalAlignment: TextInput.AlignHCenter

        onAccepted: {
            attempts++
            var result = handler.tryPassword(text)
            if (result == 0) {
                // Bad password
                unlockScreen.state = "badPassword"
                passwordField.text = ""
            } else if (result == 1) {
                // Success. Do thing.
            } else {
                // Error. Do something?
            }
        }
    }

    Label {
        id: infoText
        anchors {
            top: passwordField.bottom
            topMargin: 8
            horizontalCenter: passwordField.horizontalCenter
        }
    }

    states: State {
        name: "badPassword"

        PropertyChanges {
            target: lockIcon
            color: "darkRed"
        }
        PropertyChanges {
            target: infoText
            text: attempts > 2 ? "Bad password or corrupt state file.\nKeep trying." : "Bad password. Try again."
            horizontalAlignment: TextInput.AlignHCenter
            font.capitalization: Font.SmallCaps
            font.pixelSize: 24
        }
    }

    transitions: Transition {
        to: "badPassword"

        ColorAnimation {
            target: lockIcon
            duration: 300
        }
    }
}
