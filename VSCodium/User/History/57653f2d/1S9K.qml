import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: appListRoot

    property string filterText: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            color: "#1affffff"
            radius: 10
            border.color: searchInput.activeFocus ? "#66ffffff" : "#10ffffff"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                spacing: 10

                IconImage {
                    implicitSize: 16
                    source: Quickshell.iconPath("search-symbolic")
                }

                TextInput {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    color: "white"
                    font.pixelSize: 14
                    focus: true
                    selectByMouse: true

                    onTextChanged: appListRoot.filterText = text.toLowerCase()

                    Text {
                        text: "Search apps"
                        color: "#66ffffff"
                        font.pixelSize: 14
                        visible: searchInput.text === ""
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            clip: true

            model: DesktopEntries.applications

            delegate: Component {
                Item {
                    width: ListView.view.width

                    readonly property bool matchesFilter:
                        modelData.name.toLowerCase().indexOf(appListRoot.filterText) !== -1 ||
                        (modelData.genericName && modelData.genericName.toLowerCase().indexOf(appListRoot.filterText) !== -1)

                    height: matchesFilter ? 80 : 0
                    visible: matchesFilter

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: matchesFilter ? 4 : 0
                        radius: 12
                        color: mouseArea.containsMouse ? "#25ffffff" : "#10ffffff"
                        border.color: mouseArea.containsMouse ? "#40ffffff" : "transparent"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 16

                            IconImage {
                                Layout.preferredWidth: 48
                                Layout.preferredHeight: 48
                                Layout.alignment: Qt.AlignVCenter
                                source: Quickshell.iconPath(modelData.icon)
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 14
                                    elide: Text.ElideRight
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.comment ? modelData.comment : "Application"
                                    color: "#b3ffffff"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.execute()
                                root.shouldShow = false
                            }
                        }
                    }
                }
            }
        }
    }
}