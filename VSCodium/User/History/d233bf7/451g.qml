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
    }

    PopupWindow {
        id: tooltip
        visible: hoverArea.hovered
        //color: "transparent"
        
        anchor {
            item: root
            edges: Edges.Right
            gravity: Edges.Right // Le indica al compositor que el popup debe crecer hacia la derecha
        }

        Rectangle {
            color: Theme.primaryContainer       
            border.color: Theme.border
            border.width: 1
            radius: 4
            
            width: tooltipTextDisplay.implicitWidth + 20
            height: tooltipTextDisplay.implicitHeight + 12

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