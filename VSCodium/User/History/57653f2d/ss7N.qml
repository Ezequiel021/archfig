import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Usamos Item como raíz para que sea un contenedor genérico y reutilizable
Item {
    id: appGridRoot

    // Delegado: Cómo se ve cada aplicación
    Component {
        id: appDelegate
        Item {
            width: 90
            height: 100

            Column {
                anchors.centerIn: parent
                spacing: 8

                IconImage {
                    width: 48
                    height: 48
                    name: modelData.icon
                    anchors.horizontalCenter: parent
                }

                Text {
                    text: modelData.name
                    color: "white"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    width: 80
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    modelData.execute()
                }
            }
        }
    }

    // La vista de cuadrícula propiamente dicha
    GridView {
        anchors.fill: parent
        anchors.margins: 20
        cellWidth: 100
        cellHeight: 110
        
        model: DesktopEntries.applications
        delegate: appDelegate
    }
}