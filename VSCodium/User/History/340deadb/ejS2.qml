pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    FileView {
        id: colorFile
        path: "./Theme.json"
        blockLoading: true
    }

    readonly property var color: JSON.parse(colorFile.text || "{}")


}