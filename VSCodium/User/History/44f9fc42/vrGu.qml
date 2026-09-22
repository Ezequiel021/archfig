import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Controls
import qs.tokens
import qs.theme

Item {
    anchors.topMargin: Tokens.containerMargins
    id: root
    property var currentMonitor 
    
    property int maxWorkspaces: 5 
    
    // We need to track the ID of the active workspace globally to calculate our window
    property int activeWorkspaceId: 1
    
    // --- SLIDING WINDOW LOGIC ---
    // Centers the active workspace when possible (e.g., if on 4, shows 2-6)
    property int minVisibleId: activeWorkspaceId <= 3 ? 1 : activeWorkspaceId - 2
    property int maxVisibleId: minVisibleId + maxWorkspaces - 1

    // --- ALTERNATIVE: PAGINATION LOGIC (1-5, 6-10) ---
    // If you prefer strict pages instead of a sliding window, comment out the two lines 
    // above and uncomment the three lines below:
    // property int page: Math.floor((Math.max(1, activeWorkspaceId) - 1) / maxWorkspaces)
    // property int minVisibleId: page * maxWorkspaces + 1
    // property int maxVisibleId: minVisibleId + maxWorkspaces - 1

    // Track the currently active workspace delegate to know where to move the highlight
    property Item activeDelegate: null

    // 1. The Main Background
    Rectangle {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        height: colLayout.implicitHeight + Tokens.containerMargins * 2
        width: colLayout.implicitWidth + Tokens.containerMargins * 2

        color: Theme.primary_container
        radius: 20
    }

    // 2. The Sliding Highlight
    Rectangle {
        id: slidingHighlight
        width: 24
        height: 24
        radius: 12
        color: Theme.primary
        
        x: activeDelegate ? colLayout.x + activeDelegate.x : colLayout.x
        y: activeDelegate ? colLayout.y + activeDelegate.y : colLayout.y
        
        opacity: activeDelegate ? 1.0 : 0.0
        
        Behavior on y {
            NumberAnimation { duration: 250; easing.type: Easing.OutExpo }
        }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // 3. The Workspaces Layout
    ColumnLayout {
        id: colLayout
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: Tokens.containerMargins
        }

        spacing: 6

        Repeater {
            model: Hyprland.workspaces

            delegate: Item {
                id: delegateItem
                
                property bool isOnCorrectMonitor: modelData.monitor === Hyprland.monitorFor(root.currentMonitor)
                property bool isActuallyActive: modelData.active && isOnCorrectMonitor
                
                // Check if this workspace falls inside our dynamic 5-workspace window
                property bool isWithinLimit: modelData.id >= root.minVisibleId && modelData.id <= root.maxVisibleId

                visible: isOnCorrectMonitor && isWithinLimit
                implicitHeight: visible ? 24 : 0
                implicitWidth: visible ? 24 : 0

                // 1. Update the global active ID so the root can shift the window
                onIsActuallyActiveChanged: {
                    if (isActuallyActive) {
                        root.activeWorkspaceId = modelData.id
                    }
                }
                
                // 2. Track this specific delegate for the highlight
                property bool isVisibleAndActive: isActuallyActive && isWithinLimit
                onIsVisibleAndActiveChanged: {
                    if (isVisibleAndActive) root.activeDelegate = delegateItem
                    else if (root.activeDelegate === delegateItem) root.activeDelegate = null
                }
                
                Component.onCompleted: {
                    if (isActuallyActive) root.activeWorkspaceId = modelData.id
                    if (isVisibleAndActive) root.activeDelegate = delegateItem
                }
                
                Component.onDestruction: {
                    if (root.activeDelegate === delegateItem) root.activeDelegate = null
                }

                Button {
                    anchors.centerIn: parent
                    anchors.fill: parent
                    
                    background: Rectangle {
                        radius: 12
                        color: "#bf616a"
                        opacity: modelData.urgent ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }

                    font {
                        family: "0xProto Nerd Font"
                        bold: true
                        pixelSize: 16
                    }

                    palette.buttonText: delegateItem.isVisibleAndActive ? Theme.on_primary : Theme.on_primary_container
                    
                    text: modelData.name

                    onClicked: {
                        modelData.activate()
                    }
                }
            }
        }
    }
}