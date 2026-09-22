import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: clockRoot

    // Estas propiedades ahora recibirán los datos desde Panel.qml
    property string temp: "--°C"
    property string weatherIcon: "🌤️"

    // MANTENEMOS EL RELOJ (Este sí debe correr solo cuando el panel es visible)
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var date = new Date()
            timeText.text = date.toLocaleTimeString(Qt.locale(), "hh:mm")
            dateText.text = date.toLocaleDateString(Qt.locale(), "ddd, d MMM")
        }
    }

    // DISEÑO VISUAL (Queda exactamente idéntico al que ya tenías)
    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        radius: 16
        color: "#10ffffff"
        border.color: "#15ffffff"
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text { id: timeText; Layout.alignment: Qt.AlignHCenter; color: "white"; font.pixelSize: 64; font.bold: true }
            Text { id: dateText; Layout.alignment: Qt.AlignHCenter; color: "#b3ffffff"; font.pixelSize: 18 }

            Rectangle { Layout.preferredWidth: 100; Layout.preferredHeight: 1; color: "#20ffffff"; Layout.alignment: Qt.AlignHCenter }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 12
                Text { text: clockRoot.weatherIcon; font.pixelSize: 28 }
                Text { text: clockRoot.temp; color: "white"; font.pixelSize: 22; font.bold: true }
            }
        }
    }
}