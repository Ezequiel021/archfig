pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.tokens
import "../theme"

StackView {
    id: view
    implicitHeight: subMenu.height
    implicitWidth: Tokens.trayMenuWidth

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
                color: "red"
                height: 16
                width: Tokens.trayMenuWidth

                Text {
                    anchors.fill: parent
                    text: modelData.text
                    font.pixelSize: 12
                    color: "black"
                }
            }
        } 
    }
}