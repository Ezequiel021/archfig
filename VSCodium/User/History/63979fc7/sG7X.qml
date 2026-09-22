import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.widgets.control
import qs.templates
import qs.theme
import qs.tokens

Scope {
    id: root
    property bool shouldShow: false

    IpcHandler {
        target: "launcher"
        function toggle() {
            containerLoader.activeAsync ^= 1;
        }
    }

    LazyLoader {
        id: containerLoader
        activeAsync: false
        PanelWindow {
            id: panel
            implicitHeight: 360
            implicitWidth: 600
            color: "transparent"
            anchors.bottom: true
            exclusionMode: ExclusionMode.Ignore

            focusable: true

            HyprlandFocusGrab {
                id: grab
                windows: [panel]
                active: root.shouldShow
                onCleared: {
                    root.shouldShow = false
                }
            }

            Rectangle {
                id: container
                anchors.fill: parent

                color: Theme.background
                topLeftRadius: Tokens.fullRadius
                topRightRadius: Tokens.fullRadius
                clip: true

                Behavior on height {
                    NumberAnimation {
                        easing: Tokens.expressiveAnimEasing
                        duration: Tokens.expressiveAnimDuration
                    }
                }

                RetainableLock{
                    object: container
                    locked: container.state == "visible"
                } 

                state: "hidden"
                states: [
                    State {
                        name: "visible"
                        PropertyChanges { opacity: 1.0; y: (window.height - container.height) / 2 }
                    },
                    State {
                        name: "hidden"
                        PropertyChanges { opacity: 1.0; y: window.height }
                    }
                ]

                Component.onCompleted: {
                    state = "visible";
                }

                transitions: [
                    Transition {
                        from: "hidden"; to: "visible"
                        NumberAnimation { properties: "y,opacity"; duration: 300; easing.type: Easing.OutCubic }
                    },
                    Transition {
                        from: "visible"; to: "hidden"
                        NumberAnimation { properties: "y,opacity"; duration: 250; easing.type: Easing.InCubic }
                    }
                ]

                AppGrid {
                    anchors.fill: parent
                }
            }
        }
    }
}