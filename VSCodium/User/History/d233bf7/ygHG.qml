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
        
        anchor {
            item: root
            edges: Edges.Right
            gravity: Edges.Right
        }

        // Un contenedor invisible que nos permite aplicar un desplazamiento (offset) matemático
        Item {
            width: popupBg.width
            height: popupBg.height
            
            Rectangle {
                id: popupBg
                
                // Desplazamos 5px exactos a la derecha para cruzar el margen de la barra
                // y alinearnos con el fondo expandido de System.qml
                x: 5 
                
                color: Theme.primaryContainer       
                border.color: Theme.border
                border.width: 1
                
                // Radios asimétricos: plano a la izquierda para la unión, curvo a la derecha
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: 10
                bottomRightRadius: 10
                
                width: tooltipTextDisplay.implicitWidth + 24
                height: tooltipTextDisplay.implicitHeight + 12

                // Truco óptico: Dibujamos una línea del color del fondo sobre el borde izquierdo
                // para borrar la costura y dar la ilusión de un solo bloque sólido.
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