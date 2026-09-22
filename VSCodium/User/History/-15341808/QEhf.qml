import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../../theme"

Item {
    id: networkWidgetRoot
    anchors.margins: 8

    // Propiedades individuales en lugar de un arreglo general.
    // Inicializan en 'null' para representar la ausencia de conexión.
    property var ethNet: null
    property var wifiNet: null

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: 15
    }

    Process {
        id: nmStream
        command: ["bash", "/home/ramos/.config/quickshell/widgets/bar/scripts/nmstatus.sh"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    try {
                        let parsed = JSON.parse(data);
                        
                        // Utilizamos la función de JavaScript find() para buscar el primer objeto
                        // que coincida con el tipo. Si no existe, asignamos null.
                        networkWidgetRoot.ethNet = parsed.find(n => n.type === "ethernet") || null;
                        networkWidgetRoot.wifiNet = parsed.find(n => n.type === "wifi") || null;
                        
                    } catch (e) {
                        console.log("Error parseando red:", e);
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // ==========================================
        // TARJETA ETHERNET
        // ==========================================
        Rectangle {
            radius: 12
            color: Theme.surfaceVariant
            Layout.fillWidth: true
            Layout.preferredHeight: ethColumn.height + 20
            
            // TRUCO VISUAL: Si es 'null' (desconectado), bajamos la opacidad a la mitad
            // para darle un aspecto de "deshabilitado" sin romper la geometría.
            opacity: networkWidgetRoot.ethNet ? 1.0 : 0.5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                
                IconImage {
                    implicitSize: 40
                    source: networkWidgetRoot.ethNet 
                            ? Quickshell.iconPath("network-wired") 
                            : Quickshell.iconPath("network-wired-offline-symbolic")
                }
                
                ColumnLayout {
                    id: ethColumn
                    Layout.fillWidth: true
                    spacing: 1

                    Text {
                        Layout.fillWidth: true
                        // Operador ternario para mostrar el nombre o el estado por defecto
                        text: networkWidgetRoot.ethNet ? networkWidgetRoot.ethNet.name : "Sin conexión"
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 14
                            family: "JetBrains Mono Nerd Font"
                            bold: true
                        }
                    }
                    Text {
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 11
                            family: "JetBrains Mono Nerd Font"
                        }
                        text: networkWidgetRoot.ethNet ? (networkWidgetRoot.ethNet.device + "\n" + networkWidgetRoot.ethNet.type) : "Ethernet"
                    }
                }
            }
        }

        // ==========================================
        // TARJETA WI-FI
        // ==========================================
        Rectangle {
            radius: 12
            color: Theme.surfaceVariant
            Layout.fillWidth: true
            Layout.preferredHeight: wifiColumn.height + 20
            
            opacity: networkWidgetRoot.wifiNet ? 1.0 : 0.5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                
                IconImage {
                    implicitSize: 40
                    source: networkWidgetRoot.wifiNet 
                            ? Quickshell.iconPath("network-wireless") 
                            : Quickshell.iconPath("network-wireless-offline-symbolic")
                }
                
                ColumnLayout {
                    id: wifiColumn
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: networkWidgetRoot.wifiNet ? networkWidgetRoot.wifiNet.name : "Desconectado"
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 14
                            family: "JetBrains Mono Nerd Font"
                            bold: true
                        }
                    }
                    Text {
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 11
                            family: "JetBrains Mono Nerd Font"
                        }
                        text: networkWidgetRoot.wifiNet ? (networkWidgetRoot.wifiNet.device + "\n" + networkWidgetRoot.wifiNet.type) : "Wi-Fi"
                    }
                }
            }
        }

        // Spacer inferior para empujar ambas tarjetas hacia la parte superior 
        // y evitar que se separen si la ventana llegara a crecer verticalmente.
        Item {
            Layout.fillHeight: true
        }
    }
}