import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.widgets.control
import qs.theme
import qs.tokens

Scope {
    id: root
    property bool shouldShow: false

    IpcHandler {
        target: "launcher"
        function toggle() {
            if (root.shouldShow) {

                root.shouldShow = false;
            } else {

                root.shouldShow = true;
                containerLoader.activeAsync = true;
            }
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

                        SequentialAnimation {

                            NumberAnimation {
                                properties: "y,opacity"
                                duration: 250
                                easing.type: Easing.InCubic
                            }

                            ScriptAction {
                                script: {
                                    if (!root.shouldShow) {
                                        containerLoader.activeAsync = false;
                                    }
                                }
                            }
                        }
                    }
                ]

                AppGrid {
                    anchors.fill: parent
                }
            }
        }
    }
}