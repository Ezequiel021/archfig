
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.tokens
import "../theme"

Item {
    property bool isMenuShown: false
    property QsMenuHandle activeMenu: null
    id: systemTrayRoot

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayDelegate
                implicitHeight: 32
                implicitWidth: 32

                property var trayItem: modelData

                Image {
                    id: trayIcon
                    anchors.fill: parent
                    source: trayDelegate.trayItem.icon
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton)
                        {
                            if (systemTrayRoot.activeMenu === modelData.menu && systemTrayRoot.isMenuShown) {
                                systemTrayRoot.isMenuShown = false;
                                popupWindowLoader.active = false
                            }
                            else {
                                console.log(modelData.id);
                                systemTrayRoot.activeMenu = modelData.menu;
                                systemTrayRoot.isMenuShown = true;

                                popupWindowLoader.active = true

                                let globalPos = mapToGlobal(width / 2, height / 2)
                                trayMenuWindow.targetY = globalPos.y
                                console.log(globalPos.y)
                            }
                        }
                    }
                }
            }
        }
    }

    QsMenuOpener {
        id: dbusFetcher
        menu: systemTrayRoot.activeMenu
    }

    LazyLoader {
        id: popupWindowLoader
        PopupWindow {
            id: trayMenuWindow
            property real targetY: 0

            anchor {
                item: systemTrayRoot
                edges: Edges.Right
                gravity: Edges.Right
            }

            implicitHeight: 540
            implicitWidth: Tokens.trayMenuWidth + 4 * Tokens.containerMargins
            grabFocus: true
            color: "transparent"

            property bool isContentLoaded: false
            visible: true

            Rectangle {
                width: trayMenu.implicitWidth + 16
                height: trayMenu.implicitHeight + 16
                anchors.centerIn: parent

                color: Theme.background
                id: menuPanel
                topRightRadius: 20
                bottomRightRadius: 20

                transform: [
                    Translate {
                        id: panelTranslate
                        x: -50

                        Behavior on x {
                            NumberAnimation {
                                duration: Tokens.popupAnimationDuration
                                easing: Easing.InBack
                            }
                        }
                    },
                    Scale {
                        id: panelScale
                        xScale: 0.7
                        yScale: 0.7

                        origin.x: 0
                        origin.y: menuPanel.height

                        Behavior on yScale {
                            NumberAnimation {
                                duration: Tokens.popupAnimationDuration
                                easing: Easing.OutBack
                            }
                        }
                    }
                ]
                
                //opacity: 0.0
                Component.onCompleted: {
                    panelTranslate.x = 0
                    panelScale.xScale = 1.0
                    panelScale.yScale = 1.0
                    //growAnimation.start()
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 120
                        easing: Easing.OutBack
                    }
                }

                TrayMenu {
                    anchors.centerIn: parent
                    id: trayMenu
                    property bool isDataReady: dbusFetcher.children && dbusFetcher.children.values.length > 0
                    trayItem: systemTrayRoot.activeMenu

                    visible: systemTrayRoot.isMenuShown && systemTrayRoot.activeMenu !== null && isDataReady
                }
            }
        }
    }
}