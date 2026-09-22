pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Item {
    id: windowTitleRoot
    implicitHeight: titleText.implicitWidth
    implicitWidth: 38

    property string activeTitle: "Desktop"

    Process {
        id: mangoStream
        command: ["sh", "-c", "mmsg -g -c"]
        running: true

        stdoutParser: LineParser {
            onLine: (line) => {
                if (line.trim() !== "") {
                    windowTitleRoot.activeTitle = line.trim();
                }
                else {
                    windowTitleRoot.activeTitle = "Desktop";
                }
            }
        }
    }
}