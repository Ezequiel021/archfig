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
            root.shouldShow ^= 1;
        }
    }

    LazyLoader {
        id: containerLoader
        activeAsync: root.shouldShow

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
                width: panel.implicitWidth
                height: panel.implicitHeight

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

                state: root.shouldShow ? "visible" : "hidden"
                states: [
                    State {
                        name: "visible"
                        PropertyChanges { opacity: 1.0; y: (panel.height - container.height) / 2 }
                    },
                    State {
                        name: "hidden"
                        PropertyChanges { opacity: 1.0; y: panel.height }
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
                        NumberAnimation { id: hideAnim; properties: "y,opacity"; duration: 250; easing.type: Easing.InCubic }
                    }
                ]

                RetainableLock{
                    object: container
                    locked: root.shouldShow || hideAnim.running
                } 

                AppGrid {
                    anchors.fill: parent
                }
            }
        }
    }
}