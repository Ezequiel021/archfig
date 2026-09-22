import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Networking
import QtQuick.Controls
import qs.theme
import qs.templates
import qs.tokens

FloatingWindow {
    id: window
    visible: true
    implicitHeight: 400
    implicitWidth: 400
    color: Theme.background

    title: "Networks"

    Item {
        id: root
        anchors.fill: parent
        anchors.margins: 10

        property var currentWifiDevice: wifiDeviceModel.values[0]

        Rectangle {
            color: Theme.background
            anchors.fill: parent
        }

        ScriptModel {
            id: wifiDeviceModel
            values: {
                Networking.devices.values.filter(item => item.type === DeviceType.Wifi)
            }
        }

        ColumnLayout {
            anchors.fill: parent
            RowLayout {
                Layout.fillWidth: true
                Item {
                    Layout.preferredHeight: adapterLabel.implicitHeight
                    Layout.preferredWidth: adapterLabel.implicitWidth
                    Text {
                        id: adapterLabel
                        text: root.currentWifiDevice.name
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Item {
                    Layout.preferredHeight: scanButton.implicitHeight
                    Layout.preferredWidth: scanButton.implicitWidth
                    Button {
                        id: scanButton
                        text: root.currentWifiDevice.scannerEnabled ? "Stop" : "Scan"
                        onClicked: {
                            if (root.currentWifiDevice) {
                                root.currentWifiDevice.scannerEnabled ^= 1;
                            }
                        }
                    }
                }
            }

            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true

                // Extremely important: prevents scrolling text from overlapping your header
                clip: true

                // Add spacing between items if desired
                spacing: 5

                model: root.currentWifiDevice ? root.currentWifiDevice.networks : null

                delegate: Item {
                    id: networkEntry

                    property bool attemptingToConnect: false
                    
                    width: ListView.view.width
                    height: mainColumn.implicitHeight + 4
                    clip: true

                    StyledRect {
                        radius: Tokens.fullRadius
                        anchors.fill: parent
                        color: delegateMouseArea.containsMouse ? Theme.primary_container : "transparent"
                    }

                    Behavior on height {
                        NumberAnimation {
                            easing: Easing.OutQuad
                            duration: 160
                        }
                    }

                    MouseArea {
                        id: delegateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            networkEntry.attemptingToConnect ^= true;
                        }
                    }

                    Column {
                        id: mainColumn
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Row {
                            id: networkEntryCard
                            spacing: 10 // Adds a small gap between the icon and text
                            anchors.left: parent.left
                            anchors.leftMargin: 8

                            Image {
                                anchors.verticalCenter: parent.verticalCenter
                                source: {
                                    if (modelData.signalStrength > 0.7) return Quickshell.iconPath("network-wireless-signal-excellent-symbolic")
                                    if (modelData.signalStrength > 0.5) return Quickshell.iconPath("network-wireless-signal-good-symbolic")
                                    if (modelData.signalStrength > 0.3) return Quickshell.iconPath("network-wireless-signal-ok-symbolic")
                                    if (modelData.signalStrength > 0.0) return Quickshell.iconPath("network-wireless-signal-weak-symbolic")
                                }

                                height: 24
                                fillMode: Image.PreserveAspectFit
                            }

                            Column {
                                id: networkEntryData

                                StyledText {
                                    text: modelData.name
                                    color: Theme.on_background
                                    font.pixelSize: 16
                                    font.bold: true
                                }

                                StyledText {
                                    text: modelData.connected ? "Connected" : WifiSecurityType.toString(modelData.securityType)
                                    font.italic: true
                                    font.pixelSize: 12
                                    color: Theme.on_background
                                }
                            }
                        }

                        Column {
                            visible: opacity > 0
                            opacity: networkEntry.attemptingToConnect ? 1.0 : 0.0
                            width: parent.width

                            StyledText {
                                text: "Enter password: "
                            }

                            TextField {
                                placeholderText: "Password"
                                echoMode: TextInput.Password

                            }

                            Behavior on opacity {
                                SequentialAnimation {
                                    PauseAnimation { 
                                        duration: 160 
                                    }
                                    NumberAnimation { 
                                        duration: 50 
                                        easing: Easing.OutQuad
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: "steelblue"
                Layout.preferredHeight: 20
                RowLayout {
                    anchors.fill: parent
                    id: bottomRibbon

                    Text {
                        Layout.fillWidth: true
                        text: root.currentWifiDevice.networks.values.length + " available networks"
                    }

                    Text {
                        visible: root.currentWifiDevice.scannerEnabled
                        text: "Scanning"
                    }
                }
            }
        }
    }
}