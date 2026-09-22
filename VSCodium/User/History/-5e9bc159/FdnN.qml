pragma Singleton
import QtQuick

QtObject {
    readonly property int trayMenuWidth: 280
    readonly property int containerMargins: 8
    readonly property int popupAnimationDuration: 200

    readonly property int expressiveAnimDuration: 333
    readonly property int expressiveAnimEasing: Easing.OutCubic
}