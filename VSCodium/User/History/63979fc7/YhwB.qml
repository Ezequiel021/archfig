import QtQuick
import qs.templates
import qs.theme // Assuming your theme modules
import qs.tokens

AnimatedPanel {
    id: launcherMenu
    isOpen: false
    edge: "bottom"
    panelWidth: 600
    panelHeight: 360

    // IPC to toggle it
    IpcHandler {
        target: "launcher"
        function toggle() {
            launcherMenu.isOpen = !launcherMenu.isOpen;
        }
    }

    // Everything below becomes the 'contentComponent'
    Rectangle {
        color: Theme.background
        topLeftRadius: Tokens.fullRadius
        topRightRadius: Tokens.fullRadius
        clip: true

        AppGrid {
            anchors.fill: parent
        }
    }
}