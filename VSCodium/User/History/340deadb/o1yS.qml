pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: themeRoot
    property var colors: []

    FileView {
        id: colorFile
        path: Qt.resolvedUrl("~/.config/quickshell/widgets/theme/Theme.json")
        blockLoading: true
    }
}