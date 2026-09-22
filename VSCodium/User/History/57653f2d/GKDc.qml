import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

Item {
    id: appListRoot

    // Emitted when an app is launched so the parent window knows to close
    signal appLaunched()

    // 1. Model-Level Filtering
    // The ListView will only create delegates for the items in this array,
    // completely fixing the GPU and CPU load issues.
    property string filterText: searchField.text.toLowerCase()
    property var allApps: DesktopEntries.applications
    property var filteredApps: {
        if (filterText === "") return allApps;
        return allApps.filter(app =>
            app.name.toLowerCase().indexOf(filterText) !== -1 ||
            (app.genericName && app.genericName.toLowerCase().indexOf(filterText) !== -1)
        );
    }

    // Launch helper function
    function launchSelectedApp() {
        if (filteredApps.length > 0 && appList.currentIndex >= 0) {
            let selectedApp = filteredApps[appList.currentIndex];
            selectedApp.execute();
            searchField.clear(); // Reset search for the next time it opens
            appListRoot.appLaunched();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // 2. Upgraded Search Field
        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            
            placeholderText: "Search apps"
            placeholderTextColor: "#66ffffff"
            color: "white"
            font.pixelSize: 14
            focus: true
            selectByMouse: true
            
            // Text padding to accommodate the absolute-positioned icons
            leftPadding: 40
            rightPadding: 40

            // Reset the list selection to the top item whenever the user types
            onTextChanged: appList.currentIndex = 0

            // 3. Keyboard Navigation
            Keys.onDownPressed: {
                if (appList.currentIndex < appList.count - 1) {
                    appList.currentIndex++;
                    appList.positionViewAtIndex(appList.currentIndex, ListView.Contain);
                }
            }
            Keys.onUpPressed: {
                if (appList.currentIndex > 0) {
                    appList.currentIndex--;
                    appList.positionViewAtIndex(appList.currentIndex, ListView.Contain);
                }
            }
            Keys.onReturnPressed: appListRoot.launchSelectedApp()
            Keys.onEnterPressed: appListRoot.launchSelectedApp()

            background: Rectangle {
                color: "#1affffff"
                radius: 10
                border.color: searchField.activeFocus ? "#66ffffff" : "#10ffffff"
                border.width: 1
            }

            // Search Icon (Left)
            IconImage {
                implicitSize: 16
                source: Quickshell.iconPath("search-symbolic")
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            // Clear Button (Right)
            MouseArea {
                id: clearButton
                width: 16
                height: 16
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                cursorShape: Qt.PointingHandCursor
                visible: searchField.text !== ""
                
                onClicked: {
                    searchField.clear();
                    searchField.forceActiveFocus();
                }

                IconImage {
                    anchors.fill: parent
                    source: Quickshell.iconPath("edit-clear-symbolic")
                    opacity: clearButton.containsMouse ? 1.0 : 0.6
                }
            }
        }

        ListView {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            clip: true
            
            model: appListRoot.filteredApps
            currentIndex: 0

            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                radius: 12
                
                // Highlight item if hovered by mouse OR selected via keyboard arrows
                property bool isSelected: ListView.isCurrentItem || mouseArea.containsMouse

                color: isSelected ? "#25ffffff" : "#10ffffff"
                border.color: isSelected ? "#40ffffff" : "transparent"
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
                        // Prevents micro-stutters by fetching disk assets off the main thread
                        asynchronous: true 
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
                        appList.currentIndex = index;
                        appListRoot.launchSelectedApp();
                    }
                }
            }
        }
    }
}