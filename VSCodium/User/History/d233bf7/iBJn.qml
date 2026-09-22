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
        visible: hoverArea.hovered
        color: "transparent"
        
        // 1. La ventana debe medir exactamente lo que mide su contenedor interno
        width: popupContainer.width
        height: popupContainer.height

        // 2. Silenciamos la advertencia del linter para este bloque específico
        // qmllint disable missing-type
        anchor {
            item: root
            edges: Edges.Right
            gravity: Edges.Right
        }
        // qmllint enable missing-type

        // Contenedor invisible para poder aplicar el desplazamiento (offset) sin romper la ventana
        Item {
            id: popupContainer
            
            // El ancho total es el del fondo + los 5px de desplazamiento
            width: popupBg.width + 5
            height: popupBg.height

            Rectangle {
                id: popupBg
                // Desplazamos 5px a la derecha para cruzar el margen de la barra principal
                x: 5
                
                color: Theme.primaryContainer       
                border.color: Theme.border
                border.width: 1
                
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: 10
                bottomRightRadius: 10
                
                // Tamaño dinámico basado en el texto interno + un margen holgado (padding)
                width: tooltipTextDisplay.implicitWidth + 24
                height: tooltipTextDisplay.implicitHeight + 12

                // Línea óptica para ocultar la costura con la barra principal
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
                    font.pixelSize: 12
                }
            }
        }
    }
}