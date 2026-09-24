/*
    Hyper OS — SDDM greeting card.

    Depends only on the context properties SDDM injects into every
    theme (userModel, sessionModel, sddm.*), so it stays compatible
    with both sddm-qt5 and sddm-qt6 / greeter choices.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 640
    height: 480
    color: "#0b0e15"

    property int boxW: 300

    Image {
        id: backdrop
        anchors.fill: parent
        source: "wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: boxW + 64
        height: 300
        radius: 14
        color: "#e8101118"
        border.color: "#1cffd60a"
        border.width: 1
    }

    Image {
        id: logo
        source: "logo.png"
        anchors.top: card.top
        anchors.topMargin: 26
        anchors.horizontalCenter: card.horizontalCenter
        width: 88
        height: 88
    }

    Text {
        id: greeting
        anchors.top: logo.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: card.horizontalCenter
        text: "Hyper OS"
        color: "#e9edf4"
        font.pixelSize: 22
        font.bold: true
        font.family: "DejaVu Sans"
        horizontalAlignment: Text.AlignHCenter
    }

    Timer {
        id: clockTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: clockLabel.text = new Date().toLocaleString(Qt.locale(), "ddd MMM d  HH:mm")
    }

    Text {
        id: clockLabel
        anchors.top: greeting.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: card.horizontalCenter
        font.pixelSize: 12
        color: "#8b93a3"
        font.family: "DejaVu Sans"
    }

    Column {
        anchors.left: card.left
        anchors.right: card.right
        anchors.leftMargin: 32
        anchors.rightMargin: 32
        anchors.top: clockLabel.bottom
        anchors.topMargin: 18
        spacing: 10

        TextField {
            id: userName
            width: parent.width
            height: 38
            placeholderText: "username"
            placeholderTextColor: "#8b93a3"
            color: "#e9edf4"
            font.family: "DejaVu Sans"
            font.pixelSize: 15
            background: Rectangle { color: "#cc1e2632"; radius: 6 }
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            selectByMouse: true
            onAccepted: password.forceActiveFocus()
            Component.onCompleted: {
                for (var i = 0; i < userModel.count; ++i) {
                    userName.text = userModel.data(userModel.index(i, 0), Qt.UserRole + 1)
                    break
                }
                if (userName.text.length > 0) {
                    password.forceActiveFocus()
                } else {
                    userName.forceActiveFocus()
                }
            }
        }

        TextField {
            id: password
            width: parent.width
            height: 38
            placeholderText: "password"
            placeholderTextColor: "#8b93a3"
            color: "#e9edf4"
            font.family: "DejaVu Sans"
            font.pixelSize: 15
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            background: Rectangle { color: "#cc1e2632"; radius: 6 }
            onAccepted: sddm.login(userName.text, password.text, sessionCombo.currentText)
        }

        ComboBox {
            id: sessionCombo
            width: parent.width
            height: 38
            model: sessionModel
            font.family: "DejaVu Sans"
            font.pixelSize: 14
            onCurrentIndexChanged: if (currentText === "hyper") { /* nothing fancy */ }
            Component.onCompleted: {
                for (var i = 0; i < model.count; ++i) {
                    if (model.data(model.index(i, 0), Qt.UserRole + 1) === "hyper") {
                        currentIndex = i
                        break
                    }
                }
            }
        }

        Button {
            width: parent.width
            height: 42
            text: "Log in"
            font.family: "DejaVu Sans"
            font.pixelSize: 15
            font.bold: true
            palette { buttonText: "#0b0e15"; button: "#ffd60a" }
            onClicked: sddm.login(userName.text, password.text, sessionCombo.currentText)
        }
    }
}