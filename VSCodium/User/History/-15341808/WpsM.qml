import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "../../theme"

Item {
    id: networkWidgetRoot
    anchors.margins: 8

    // Propiedades alimentadas por el script
    property var ethNet: null
    property var wifiNet: null

    // === PROPIEDADES EXPUESTAS PARA EL PANEL PRINCIPAL ===
    // Orden de prioridad: Ethernet -> Wi-Fi -> Desconectado
    property string panelIcon: {
        if (ethNet) return Quickshell.iconPath("network-wired-symbolic")
        if (wifiNet) return Quickshell.iconPath("network-wireless-signal-excellent-symbolic")
        return Quickshell.iconPath("network-wireless-offline-symbolic")
    }
    
    property string tooltipText: {
        if (ethNet) return "Red: " + ethNet.name
        if (wifiNet) return "Red: " + wifiNet.name
        return "Desconectado"
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: 15
    }

    // Restauramos el proceso en segundo plano
    Process {
        id: nmStream
        command: ["bash", "/home/ramos/.config/quickshell/widgets/bar/scripts/nmstatus.sh"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    try {
                        let status = JSON.parse(data);
                        systemTrayRoot.batLevel = status.battery;
                        systemTrayRoot.batStatus = status.bat_status;
                        systemTrayRoot.btState = status.bluetooth;
                        
                        // INYECCIÓN MÁGICA: Pasamos el arreglo completo al widget de red
                        wifiWidget.activeNetworks = status.networks;
                    } catch (e) {
                        console.log("Error parseando el estado del sistema:", e);
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

                    Text {
                        Layout.fillWidth: true
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

        Item {
            Layout.fillHeight: true
        }
    }
}