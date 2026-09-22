pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.tokens
import "../theme"

StackView {
    id: view

    implicitWidth: view.currentItem ? view.currentItem.implicitWidth : 260
    implicitHeight: view.currentItem ? view.currentItem.implicitHeight : 100

    property QsMenuHandle trayItem

    initialItem: subMenu

    SubMenu {
        id: subMenu
    }

    QsMenuOpener {
        id: trayMenu
        menu: view.trayItem
    }

    component SubMenu: Column {
        spacing: 2
        Repeater{
            model: trayMenu.children
            Rectangle {
                id: item
                required property QsMenuEntry modelData
                color: "red"
                height: label.implicitHeight + 4
                width: Tokens.trayMenuWidth

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.text
                        font {
                            pixelSize: 16
                            family: "JetBrains Mono Nerd Font"
                        }
                        color: "black"
                    }
                }
                
            }
        } 
    }
}