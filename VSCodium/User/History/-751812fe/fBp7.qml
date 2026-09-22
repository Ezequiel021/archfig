pragma Singleton
import QtQuick
QtObject {
    component StyledText: Text {
        font {
            family: "Noto Sans"
        }
    }

    component MonoText: Text {
        font {
            family: "JetBrains Mono Nerd Font"
        }
    }
}