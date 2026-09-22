import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: appListRoot

    // Delegado: Cómo se ve cada tarjeta de aplicación
    Component {
        id: appCardDelegate
        
        Item {
            // Definimos el ancho completo de la lista y un alto cómodo para la tarjeta
            width: ListView.view.width
            height: 80

            // Fondo de la tarjeta con efecto hover / interactivo
            Rectangle {
                anchors {
                    fill: parent
                    margins: 4 // Pequeño margen para separar las tarjetas entre sí
                }
                radius: 12
                // Cambia ligeramente de color si pasamos el cursor por encima
                color: mouseArea.containsMouse ? "#25ffffff" : "#10ffffff"
                border.color: mouseArea.containsMouse ? "#40ffffff" : "transparent"
                border.width: 1

                // Contenedor horizontal para alinear Icono -> Textos
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 16

                    // 1. ÍCONO DE LA APLICACIÓN
                    IconImage {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        Layout.alignment: Qt.AlignVCenter
                        source: Quickshell.iconPath(modelData.icon)
                    }

                    // 2. TEXTOS (Nombre y Descripción)
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        // Nombre del programa
                        Text {
                            Layout.fillWidth: true
                            text: modelData.name
                            color: "white"
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                        }

                        // Descripción o categoría del programa
                        Text {
                            Layout.fillWidth: true
                            // Usamos genericName (ej: "Navegador Web"). Si no tiene, se oculta.
                            text: modelData.comment ? modelData.comment : "Application"
                            color: "#b3ffffff" // Color blanco semi-transparente para dar jerarquía visual
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }
                }

                // Área de interacción
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true // Habilita el cambio de color al pasar el ratón
                    
                    onClicked: {
                        modelData.execute()
                    }
                }
            }
        }
    }

    // Cambiamos GridView por ListView
    ListView {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 6 // Espacio vertical entre cada tarjeta
        clip: true // Evita que las tarjetas se salgan visualmente del contenedor al scrollear
        
        model: DesktopEntries.applications
        delegate: appCardDelegate
    }
}