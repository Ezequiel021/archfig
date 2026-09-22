import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: themeRoot
    property var colors: []

    Process {
        id: colorStream
        command: ["cat", "~/home/ramos/.config/quickshell/widgets/theme/Theme.json"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    try {
                        let parsed = JSON.parse(data)
                        themeRoot.colors = parsed
                    } catch (e) {
                        console.log("Error parseando el JSON de color")
                    }
                }
            }
        }
    }
}