import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import qs.widgets.control

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
            anchors.bottom: true
            margins.bottom: (1080 - 800) / 2
            exclusiveZone: 0

            implicitWidth: 1400
            implicitHeight: 800
            color: "transparent"

            keyboardFocus: LayerShellFocus.Exclusive

            Rectangle {
                id: panelContent
                anchors.fill: parent
                radius: 30
                color: "#80000000"

                focus: true
                Component.onCompleted: panelContent.forceActiveFocus()
                onActiveFocusChanged: {
                    if (!panelContent.activeFocus) {
                        root.shouldShow = false
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 30
                        rightMargin: 30
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