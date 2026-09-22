import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import qs.widgets.control
import Quickshell.Hyprland

Scope {
    id: root

    IpcHandler {
        target: "control-panel"

        function toggle() {
            root.shouldShow = !root.shouldShow
        }
    }

    property bool shouldShow: false
    LazyLoader {
        active: root.shouldShow
        PanelWindow {
            id: window
            anchors.bottom: true
            margins.bottom: (1080 - 800) / 2
            exclusiveZone: 0

            implicitWidth: 1400
            implicitHeight: 800
            color: "transparent"

            focusable: true

            HyprlandFocusGrab {
                id: grab
                windows: [window]
                active: root.shouldShow
                onCleared: {
                    root.shouldShow = false
                }
            }

            Shortcut {
                sequence: "Escape"
                enabled: root.shouldShow
                onActivated: {
                    root.shouldShow = false
                }
            }

            Rectangle {
                id: panelContent
                anchors.fill: parent
                radius: 30
                color: '#3d364d'

                RowLayout {
                    anchors {
                        fill: parent
                        margins: 30
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"
                        radius: 24

                        AppGrid {
                            anchors.fill: parent
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#50ffffff"
                        Text {
                            color: "white"
                            anchors.centerIn: parent
                            text: "2"
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        color: "#90ffffff"
                        Text {
                            color: "white"
                            anchors.centerIn: parent
                            text: "3"
                        }
                    }
                }
            }
        }
    }

}