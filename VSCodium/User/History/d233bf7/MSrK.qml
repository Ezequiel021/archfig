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
    
    HoverHandler {
        id: hoverArea
    }

    Button {
        background: Rectangle {
            color: "transparent"
        }
        icon.source: root.iconSource
    }

    PopupWindow {
        id: tooltip
        visible: hoverArea.hovered
        
        // CORRECCIÓN: Usamos 'item' en lugar de 'rect'
        anchor {
            item: root
            edges: Edges.Right
            gravity: Edges.Right // Le indica al compositor que el popup debe crecer hacia la derecha
        }

        Rectangle {
            color: Theme.background       
            border.color: Theme.border
            border.width: 1
            radius: 4
            
            width: tooltipTextDisplay.implicitWidth + 20
            height: tooltipTextDisplay.implicitHeight + 12

            Text {
                id: tooltipTextDisplay
                anchors.centerIn: parent
                text: root.tooltipText
                color: Theme.text
                font.pixelSize: 12
            }
        }
    }
}