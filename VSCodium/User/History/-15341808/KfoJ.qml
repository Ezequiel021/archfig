import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking // El módulo nativo de C++
import "../../theme"

Item {
    id: networkWidgetRoot
    anchors.margins: 8

    // ==========================================
    // LÓGICA NATIVA DE HARDWARE
    // ==========================================
    // Enlazamos directamente a los dispositivos primarios del sistema
    property var ethDev: Networking.primaryWiredDevice
    property var wifiDev: Networking.primaryWifiDevice

    // Evaluamos si están conectados verificando que tengan una red asignada
    property bool isEthConnected: ethDev && ethDev.hasLink && ethDev.network
    property bool isWifiConnected: wifiDev && wifiDev.network

    // ==========================================
    // PROPIEDADES EXPUESTAS (Para System.qml)
    // ==========================================
    
    // 1. Ícono de la barra (Prioridad: Sin conexión > Ethernet > Wi-Fi)
    readonly property string currentTrayIcon: {
        if (!isEthConnected && !isWifiConnected) {
            return Quickshell.iconPath("network-wireless-offline-symbolic")
        }
        if (isEthConnected) {
            return Quickshell.iconPath("network-wired-symbolic")
        }
        // Si no es Ethernet y hay conexión, asumimos Wi-Fi
        return Quickshell.iconPath("network-wireless-signal-excellent-symbolic")
    }

    // 2. Tooltip de la barra
    readonly property string currentTooltip: {
        if (!isEthConnected && !isWifiConnected) return "Red: Desconectado"
        if (isEthConnected) return "Red: " + ethDev.network.name
        return "Red: " + wifiDev.network.name
    }

    // ==========================================
    // INTERFAZ DE USUARIO
    // ==========================================
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: 15
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // --- TARJETA ETHERNET ---
        Rectangle {
            radius: 12
            color: Theme.surfaceVariant
            Layout.fillWidth: true
            Layout.preferredHeight: ethColumn.height + 20
            
            // Opacidad controlada por la API nativa
            opacity: networkWidgetRoot.isEthConnected ? 1.0 : 0.5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                
                IconImage {
                    implicitSize: 40
                    source: networkWidgetRoot.isEthConnected 
                            ? Quickshell.iconPath("network-wired") 
                            : Quickshell.iconPath("network-wired-offline-symbolic")
                }
                
                ColumnLayout {
                    id: ethColumn
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: networkWidgetRoot.isEthConnected ? ethDev.network.name : "Sin conexión"
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 14
                            family: "JetBrains Mono Nerd Font"
                            bold: true
                        }
                    }
                    Text {
                        color: Theme.oNSurfaceVariant
                        font { pixelSize: 11; family: "JetBrains Mono Nerd Font" }
                        text: networkWidgetRoot.isEthConnected ? (ethDev.name + "\nEthernet") : "Ethernet"
                    }
                }
            }
        }

        // --- TARJETA WI-FI ---
        Rectangle {
            radius: 12
            color: Theme.surfaceVariant
            Layout.fillWidth: true
            Layout.preferredHeight: wifiColumn.height + 20
            
            opacity: networkWidgetRoot.isWifiConnected ? 1.0 : 0.5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                
                IconImage {
                    implicitSize: 40
                    source: networkWidgetRoot.isWifiConnected 
                            ? Quickshell.iconPath("network-wireless") 
                            : Quickshell.iconPath("network-wireless-offline-symbolic")
                }
                
                ColumnLayout {
                    id: wifiColumn
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: networkWidgetRoot.isWifiConnected ? wifiDev.network.name : "Desconectado"
                        color: Theme.oNSurfaceVariant
                        font {
                            pixelSize: 14
                            family: "JetBrains Mono Nerd Font"
                            bold: true
                        }
                    }
                    Text {
                        color: Theme.oNSurfaceVariant
                        font { pixelSize: 11; family: "JetBrains Mono Nerd Font" }
                        text: networkWidgetRoot.isWifiConnected ? (wifiDev.name + "\nWi-Fi") : "Wi-Fi"
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}