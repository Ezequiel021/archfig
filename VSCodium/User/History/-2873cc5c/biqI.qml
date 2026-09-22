import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: clockRoot

    // Propiedades internas para el clima
    property string temp: "--°C"
    property string weatherIcon: "🌤️"

    // ==========================================
    // LÓGICA DEL RELOJ (Timer)
    // ==========================================
    Timer {
        interval: 1000 // Se ejecuta cada 1 segundo (1000ms)
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var date = new Date()
            // Formato de hora: 14:30
            timeText.text = date.toLocaleTimeString(Qt.locale(), "hh:mm")
            // Formato de fecha corta: mar, 23 jun
            dateText.text = date.toLocaleDateString(Qt.locale(), "ddd, d MMM")
        }
    }

    // ==========================================
    // LÓGICA DEL CLIMA (API HTTP)
    // ==========================================
    Timer {
        interval: 900000 // Actualiza el clima cada 15 minutos (900,000 ms)
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchWeather()
    }

    function fetchWeather() {
        var xhr = new XMLHttpRequest()
        // Usamos wttr.in con formato JSON (?format=j1)
        xhr.open("GET", "https://wttr.in/?format=j1")
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText)
                var current = response.current_condition[0]
                
                // Extrae la temperatura actual
                clockRoot.temp = current.temp_C + "°C"
                
                // Mapea el código del clima a un emoji (puedes expandir esto)
                var desc = current.weatherDesc[0].value.toLowerCase()
                if (desc.includes("sunny") || desc.includes("clear")) clockRoot.weatherIcon = "☀️"
                else if (desc.includes("cloud")) clockRoot.weatherIcon = "☁️"
                else if (desc.includes("rain") || desc.includes("shower")) clockRoot.weatherIcon = "🌧️"
                else if (desc.includes("snow")) clockRoot.weatherIcon = "❄️"
                else if (desc.includes("thunder")) clockRoot.weatherIcon = "⛈️"
                else clockRoot.weatherIcon = "🌤️"
            }
        }
        xhr.send()
    }

    // ==========================================
    // DISEÑO VISUAL (UI)
    // ==========================================
    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        radius: 16
        color: "#10ffffff" // Fondo de tarjeta sutil igual que el lanzador
        border.color: "#15ffffff"
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            // 1. LA HORA (Fuente grande)
            Text {
                id: timeText
                Layout.alignment: Qt.AlignHCenter
                color: "white"
                font.pixelSize: 64
                font.bold: true
                font.family: "Sans" // Puedes cambiarlo por "Inter", "Roboto", etc.
            }

            // 2. LA FECHA CORTA
            Text {
                id: dateText
                Layout.alignment: Qt.AlignHCenter
                color: "#b3ffffff" // Blanco suavizado
                font.pixelSize: 18
                font.weight: Font.Medium
            }

            // Separador sutil
            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 1
                color: "#20ffffff"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 5
                Layout.bottomMargin: 5
            }

            // 3. CLIMA (Icono y Temperatura al lado)
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 12

                Text {
                    text: clockRoot.weatherIcon
                    font.pixelSize: 28
                }

                Text {
                    text: clockRoot.temp
                    color: "white"
                    font.pixelSize: 22
                    font.bold: true
                }
            }
        }
    }
}