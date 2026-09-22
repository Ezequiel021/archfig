pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: themeRoot

    FileView {
        id: colorFile
        path: Qt.resolvedUrl("~/.config/quickshell/widgets/theme/Theme.json")
        blockLoading: true
    }

    readonly property var color: JSON.parse(colorFile.text || "{}")
}