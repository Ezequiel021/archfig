import QtQuick
import Quickshell
import Quickshell.Io
import qs.templates

Scope {
    id: root
    property bool should_show: true

    IpcHandler {
        target: "sidepanel"
        function toggle() {
            panel.isOpen = !panel.isOpen;
        }
    }


    AnimatedPanel {
        id: panel
        edge: "right"
        panelWidth: 600
        panelHeight: 1000
        isOpen: root.should_show

        Rectangle {
            anchors.fill: parent
            color: "white"
        }
    }
}
