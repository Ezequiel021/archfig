pragma Singleton
import QtQuick

QtObject {
    readonly property int trayMenuWidth: 280
    readonly property int containerMargins: 8
    readonly property int popupAnimationDuration: 200

    QtObject {
        id: anim
        readonly property int duration: 333
    }
}