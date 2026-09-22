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
            if (root.shouldShow) {
                // If it's visible, just change the state flag. 
                // The animation will handle the destruction when it finishes.
                root.shouldShow = false;
            } else {
                // If it's hidden, set the flag and immediately load the component
                root.shouldShow = true;
                containerLoader.activeAsync = true;
            }
        }
    }

    LazyLoader {
        id: containerLoader
        // REMOVED the direct binding here! It starts false and is managed manually.
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
                    // Trigger the exit sequence when focus is lost
                    root.shouldShow = false;
                }
            }

            Rectangle {
                id: container
                property bool isReady: false
                
                width: parent.width
                height: parent.height
                color: Theme.background
                topLeftRadius: Tokens.fullRadius
                topRightRadius: Tokens.fullRadius
                clip: true

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
                        NumberAnimation { 
                            id: hideAnim
                            properties: "y,opacity"
                            duration: 250 
                            easing.type: Easing.InCubic 
                            
                            // THE MAGIC HAPPENS HERE:
                            // Wait for the animation to actually finish, then destroy the window
                            onFinished: {
                                if (!root.shouldShow) {
                                    containerLoader.activeAsync = false;
                                }
                            }
                        }
                    }
                ]

                // (Removed RetainableLock as it is no longer needed with this approach)

                AppGrid {
                    anchors.fill: parent
                }
            }
        }
    }
}