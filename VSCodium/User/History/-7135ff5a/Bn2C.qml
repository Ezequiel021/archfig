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
    
    // Calculate visible range (2 workspaces on each side of active)
    property int activeWsIndex: {
        let workspaces = getMonitorWorkspaces()
        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].active) return i
        }
        return 0
    }
    
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
                
                // Calculate if this workspace should be visible (within window of 5)
                property int wsIndex: {
                    let workspaces = root.getMonitorWorkspaces()
                    return workspaces.indexOf(modelData)
                }
                
                property bool inVisibleRange: {
                    if (modelData.monitor !== Hyprland.monitorFor(root.currentMonitor)) return false
                    return Math.abs(wsIndex - root.activeWsIndex) <= 2
                }
                
                visible: inVisibleRange
                implicitHeight: visible ? 24 : 0
                implicitWidth: visible ? 24 : 0
                
                onIsActiveChanged: {
                    if (isActive) root.activeDelegate = delegateItem
                }
                
                Component.onCompleted: {
                    if (isActive) root.activeDelegate = delegateItem
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