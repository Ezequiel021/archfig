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
    
    // Track the currently active workspace delegate
    property Item activeDelegate: null
    property int activeWsIndex: 0
    
    // Get filtered workspaces for current monitor
    function getMonitorWorkspaces() {
        let result = []
        for (let i = 0; i < Hyprland.workspaces.model.length; i++) {
            let ws = Hyprland.workspaces.model[i]
            if (ws.monitor === Hyprland.monitorFor(root.currentMonitor)) {
                result.push(ws)
            }
        }
        return result
    }
    
    // Update active workspace index whenever workspaces change
    Connections {
        target: Hyprland.workspaces
        function onModelChanged() {
            updateActiveIndex()
        }
    }
    
    function updateActiveIndex() {
        let workspaces = getMonitorWorkspaces()
        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].active) {
                root.activeWsIndex = i
                return
            }
        }
    }
    
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
                
                property bool isActive: modelData.active && modelData.monitor === Hyprland.monitorFor(root.currentMonitor)
                
                // Calculate this workspace's index among monitor workspaces
                property int wsIndex: {
                    let workspaces = root.getMonitorWorkspaces()
                    return workspaces.indexOf(modelData)
                }
                
                // Show only 5 workspaces around the active one (2 before, current, 2 after)
                property bool inVisibleRange: {
                    if (modelData.monitor !== Hyprland.monitorFor(root.currentMonitor)) return false
                    
                    let workspaces = root.getMonitorWorkspaces()
                    let total = workspaces.length
                    
                    // Handle edge cases for small workspace counts
                    if (total <= 5) return true
                    
                    let start = Math.max(0, root.activeWsIndex - 2)
                    let end = Math.min(total - 1, root.activeWsIndex + 2)
                    
                    // Adjust range if we're near the edges
                    if (end - start < 4) {
                        if (root.activeWsIndex < 2) {
                            end = Math.min(total - 1, 4)
                        } else {
                            start = Math.max(0, total - 5)
                        }
                    }
                    
                    return wsIndex >= start && wsIndex <= end
                }
                
                visible: inVisibleRange
                implicitHeight: visible ? 24 : 0
                implicitWidth: visible ? 24 : 0
                
                onIsActiveChanged: {
                    if (isActive) {
                        root.activeDelegate = delegateItem
                        root.updateActiveIndex()
                    }
                }
                
                Component.onCompleted: {
                    if (isActive) {
                        root.activeDelegate = delegateItem
                        root.updateActiveIndex()
                    }
                }
                
                Component.onDestruction: {
                    if (root.activeDelegate === delegateItem) {
                        root.activeDelegate = null
                        root.updateActiveIndex()
                    }
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
                    
                    palette.buttonText: delegateItem.isActive ? Theme.on_primary : Theme.on_primary_container
                    
                    text: modelData.name
                    
                    onClicked: {
                        modelData.activate()
                    }
                }
            }
        }
    }
}