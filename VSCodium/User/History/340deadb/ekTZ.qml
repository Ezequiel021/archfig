import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    Process {
        stdout: SplitParser {
            onRead: (data) => {
                if
            }
        }
    }
}