import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    Process {
        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    try {
                        let parsed = JSON.parse(data)
                    } catch (e) {
                        
                    }
                }
            }
        }
    }
}