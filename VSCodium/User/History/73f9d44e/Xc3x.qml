import QtQuick
import "../theme"
Item {
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: 20
    }
    Text {
        color: Theme.oNPrimaryContainer
        font {
            family: "JetBrains Mono Nerd Font"
            bold: true
            pixelSize: 18
        }
        text: Time.time
    }
}