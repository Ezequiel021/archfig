import QtQuick
import Quickshell

Scope {
    id: root
    property bool isOpen: false
    property int popupWidth: 100
    property int popupHeight: 100
    property string edge: "left"

    default property Component contentComponent
    property PopupAnchor anchor

    onIsOpenChanged: {
        if (isOpen) {
            containerLoader.activeAsync = true;
        }
    }

    LazyLoader {
        id: containerLoader
        activeAsync: false

        PopupWindow {
            id: popup
            implicitHeight: root.popupHeight
            implicitWidth: root.popupWidth
            color: "transparent"
            anchor: root.anchor

            Item {
                id: container
                property bool isReady: false

                width: parent.width
                height: parent.height

                property real hiddenX: root.edge === "left" ? -width : (root.edge === "right" ? width : 0)

                property real hiddenY: root.edge === "top" ? -height : (root.edge === "bottom" ? height : 0)

                state: (root.isOpen && isReady) ? "visible" : "hidden"

                Component.onCompleted: {
                    isReady = true;
                }

                states: [
                    State {
                        name: "visible"
                        PropertyChanges { container.opacity: 1.0; container.x: 0; container.y: 0 }
                    },
                    State {
                        name: "hidden"
                        PropertyChanges { container.opacity: 0.0; container.x: container.hiddenX; container.y: container.hiddenY }
                    }
                ]

                transitions: [
                    Transition {
                        from: "hidden"; to: "visible"
                        NumberAnimation { properties: "x,y,opacity"; duration: 300; easing.type: Easing.OutCubic }
                    },
                    Transition {
                        from: "visible"; to: "hidden"

                        SequentialAnimation {
                            NumberAnimation {
                                properties: "x,y,opacity"
                                duration: 250
                                easing.type: Easing.InCubic
                            }

                            ScriptAction {
                                script: {
                                    if (!root.isOpen) {
                                        containerLoader.activeAsync = false;
                                    }
                                }
                            }
                        }
                    }
                ]

                Loader {
                    anchors.fill: parent
                    sourceComponent: root.contentComponent
                }
            }

        }
    }
}