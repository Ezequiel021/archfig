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
            root.shouldShow = !root.shouldShow; 
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
                
                // A flag to prevent the "Initial State" trap
                property bool isReady: false
                
                width: parent.width
                height: parent.height
                color: Theme.background
                topLeftRadius: Tokens.fullRadius
                topRightRadius: Tokens.fullRadius
                clip: true

                // When spawning, isReady is false, so it forces the "hidden" state.
                // A millisecond later, isReady becomes true, flipping the state to "visible" and triggering the transition.
                state: (root.shouldShow && isReady) ? "visible" : "hidden"

                Component.onCompleted: {
                    isReady = true; 
                }

                states: [
                    State {
                        name: "visible"
                        PropertyChanges { target: container; opacity: 1.0; y: 0 }
                    },
                    State {
                        name: "hidden"
                        PropertyChanges { target: container; opacity: 0.0; y: panel.height }
                    }
                ]

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

                RetainableLock {
                    object: panel
                    // Keep the window alive as long as we want it shown, OR if the exit animation is actively playing
                    locked: root.shouldShow || hideAnim.running
                } 

                AppGrid {
                    anchors.fill: parent
                }
            }
        }
    }
}