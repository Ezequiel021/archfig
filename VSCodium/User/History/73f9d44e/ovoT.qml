import QtQuick
import "../theme"
Text {
    color: Theme.oNPrimaryContainer
    font {
        family: "JetBrains Mono Nerd Font"
    }
    text: Time.time
}