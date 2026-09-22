import QtQuick
import QtQuick.Effects // <-- El módulo nativo de efectos en Qt6
import Quickshell
import Quickshell.Widgets
import QtQuick.Controls
import "../theme"

Item {
    id: root
    implicitWidth: 25
    implicitHeight: 25

    property string iconSource: ""
    property string tooltipText: ""
    property color iconColor: Theme.text 
    property alias isHovered: hoverArea.hovered
    
    HoverHandler {
        id: hoverArea
    }

    Behavior on iconColor {
        ColorAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    Button {
        anchors.centerIn: parent
        anchors.fill: parent

        background: Rectangle {
            color: "transparent"
        }

        icon {
            source: root.iconSource
            color: root.iconColor
            width: 25
            height: 25
        }

        hoverEnabled: true
        onHoveredChanged: {
            hovered: hoverArea.hovered
        }
    }

    PopupWindow {
        id: tooltip
        visible: false
        color: "transparent"
        width: popupContainer.width
        height: popupContainer.height

        // qmllint disable missing-type
        anchor {
            item: root
            edges: Edges.Right
            gravity: Edges.Right
        }
        // qmllint enable missing-type

        Item {
            id: popupContainer
            width: popupBg.width + 5
            height: popupBg.height

            Rectangle {
                id: popupBg
                
                // LÓGICA DE ANIMACIÓN: 
                // Si el cursor entra, x va a 5 (alineado a la barra) y opacidad a 1.
                // Si sale, x retrocede a -10 (escondiéndose a la izquierda) y opacidad a 0.
                x: hoverArea.hovered ? 5 : -10
                opacity: hoverArea.hovered ? 1.0 : 0.0
                
                // COMPORTAMIENTOS (Behaviors)
                Behavior on x {
                    NumberAnimation { 
                        duration: 250 
                        // OutBack da un micro-rebote elegante al terminar de deslizarse
                        easing.type: Easing.OutBack 
                    }
                }
                Behavior on opacity {
                    NumberAnimation { 
                        duration: 200 
                        easing.type: Easing.InOutQuad 
                    }
                }

                color: Theme.primaryContainer
                
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: 10
                bottomRightRadius: 10
                
                width: tooltipTextDisplay.implicitWidth + 24
                height: tooltipTextDisplay.implicitHeight + 24

                // Línea óptica para ocultar la costura
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 2
                    color: Theme.primaryContainer
                    visible: Theme.border !== "transparent"
                }

                Text {
                    id: tooltipTextDisplay
                    anchors.centerIn: parent
                    text: root.tooltipText
                    color: Theme.oNPrimaryContainer 
                    
                    font {
                        pixelSize: 16
                        family: "JetBrains Mono"
                    }
                }
            }
        }
    }
}