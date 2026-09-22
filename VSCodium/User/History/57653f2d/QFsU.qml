import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

Item {
    id: appListRoot

    // Emits when an app is launched so the parent window knows to close
    signal appLaunched()

    // The filtered list we will feed to the ListView
    property var filteredApps: []

    // Function to filter apps in memory, not in the renderer
    function updateFilter() {
        let allApps = DesktopEntries.applications;
        let term = searchInput.text.toLowerCase();

        if (term === "") {
            filteredApps = allApps;
        } else {
            filteredApps = allApps.filter(app => 
                app.name.toLowerCase().includes(term) ||
                (app.genericName && app.genericName.toLowerCase().includes(term))
            );
        }
        
        // Always reset selection to the top item when the search changes
        listView.currentIndex = 0;
    }

    // Update filter when Quickshell updates its application list
    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            appListRoot.updateFilter();
        }
    }

    // Initial load
    Component.onCompleted: updateFilter()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Replaced standard TextInput with a TextField for native placeholders and clear button support
        TextField {
            id: searchInput
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            
            placeholderText: "Search apps"
            placeholderTextColor: "#66ffffff"
            color: "white"
            font.pixelSize: 14
            focus: true
            selectByMouse: true

            // Trigger our JS filter when typing
            onTextChanged: appListRoot.updateFilter()

            // Intercept keyboard navigation and route it to the ListView
            Keys.onUpPressed: listView.decrementCurrentIndex()
            Keys.onDownPressed: listView.incrementCurrentIndex()
            Keys.onReturnPressed: {
                if (appListRoot.filteredApps.length > 0) {
                    appListRoot.filteredApps[listView.currentIndex].execute();
                    appListRoot.appLaunched();
                }
            }
            Keys.onEscapePressed: {
                // Optional: Let Escape clear the search, or close the menu if already empty
                if (text !== "") {
                    text = "";
                } else {
                    appListRoot.appLaunched(); // Parent can use this to close
                }
            }

            // Custom styling for the TextField background
            background: Rectangle {
                color: "#1affffff"
                radius: 10
                border.color: searchInput.activeFocus ? "#66ffffff" : "#10ffffff"
                border.width: 1
            }

            // Left search icon inside the TextField
            IconImage {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                implicitSize: 16
                source: Quickshell.iconPath("search-symbolic")
            }

            leftPadding: 45 // Make room for the search icon
            rightPadding: 40 // Make room for the clear button

            // Right clear button (only visible when text exists)
            MouseArea {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 45
                visible: searchInput.text !== ""
                cursorShape: Qt.PointingHandCursor
                
                onClicked: searchInput.text = ""

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: 16
                    source: Quickshell.iconPath("edit-clear-symbolic")
                    opacity: 0.6
                }
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            clip: true

            // Now we bind to the pre-filtered array, not the raw Quickshell list
            model: appListRoot.filteredApps

            delegate: Component {
                Item {
                    width: ListView.view.width
                    height: 80 
                    
                    // The magic trick: visually sync the keyboard cursor and the mouse hover
                    property bool isSelected: ListView.view.currentIndex === index
                    property bool isHovered: mouseArea.containsMouse

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4 
                        radius: 12
                        
                        // Highlight if hovered OR selected via keyboard
                        color: (isSelected || isHovered) ? "#25ffffff" : "#10ffffff"
                        border.color: (isSelected || isHovered) ? "#40ffffff" : "transparent"
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
                            
                            // Keep keyboard index synced with mouse position
                            onEntered: ListView.view.currentIndex = index
                            
                            onClicked: {
                                modelData.execute();
                                appListRoot.appLaunched();
                            }
                        }
                    }
                }
            }
        }
    }
}