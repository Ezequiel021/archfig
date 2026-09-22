pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.tokens
import "../theme"

StackView {

    Rectangle {
        anchors.fill: parent
    }
    id: view

    width: view.currentItem ? view.currentItem.implicitWidth : 260
    height: view.currentItem ? view.currentItem.implicitHeight : 100

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