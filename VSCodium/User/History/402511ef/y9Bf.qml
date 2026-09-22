import Quickshell
import QtQuick
import QtQuick.Layouts
import "../theme/"

// qmllint disable uncreatable-type
Scope {
    Variants {
        model: Quickshell.screens;

        PanelWindow {
            required property var modelData
            screen: modelData

            color: Theme.background
            
            anchors {
                top: true
                left: true
                bottom: true
            }

            implicitWidth: 48

            ColumnLayout {
                anchors {
                    fill: parent
                }

                // ======= Tags =======
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 280

                    Tags {
                        anchors.fill: parent
                    }
                }

                // ======= Title =======
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Title {
                        anchors.fill: parent
                    }
                }

                // ======= System tray =======
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80

                    Systemtray {
                        anchors.fill: parent
                    }
                }

                // ======= Clock =======
                Rectangle {
                    color: Theme.primaryContainer
                    radius: 20

                    Layout.fillWidth: true
                    Layout.margins: 5
                    Layout.preferredHeight: 60
                    ClockWidget {
                        anchors.fill: parent
                    }
                }
                
                // ======= Hardware =======
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200

                    System {
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}