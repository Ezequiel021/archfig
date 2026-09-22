import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: mediaWidget

    // 1. Obtenemos la lista de reproductores MPRIS actuales
    property var players: Mpris.players.values

    property int currentPlayerIndex: 0
    // 2. Seleccionamos el primer reproductor activo (si existe)
    property var player: players.length > 0 ? players[currentPlayerIndex % players.length] : null

    // 3. Extraemos la URL de la portada a partir de los metadatos
    property string albumArt: player && player.trackArtUrl ? player.trackArtUrl : ""

    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        radius: 16
        color: "#10ffffff"

        Item {
            visible: mediaWidget.player
            anchors.fill: parent
            ColumnLayout {
                anchors.margins: 20
                anchors.fill: parent
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ClippingWrapperRectangle {
                        visible: mediaWidget.albumArt !== ""
                        radius: 12
                        anchors.centerIn: parent
                        color: "transparent"

                        width: Math.min(parent.width, parent.height)
                        height: width // El alto es exactamente igual al ancho

                        Image {
                            id: artImage
                            anchors.fill: parent
                            source: mediaWidget.albumArt

                            // 2. Usamos Crop para que la imagen se expanda y llene todo el cuadrado
                            fillMode: Image.PreserveAspectCrop
                            visible: mediaWidget.albumArt !== ""
                            mipmap: true
                        }
                    }

                    Rectangle {
                        visible: mediaWidget.albumArt === ""
                        radius: 12
                        anchors.centerIn: parent
                        color: "#1affffff"

                        width: Math.min(parent.width, parent.height)
                        height: width // El alto es exactamente igual al ancho

                        IconImage {
                            implicitSize: 100
                            anchors.centerIn: parent
                            source: Quickshell.iconPath("audio-x-generic-symbolic")

                            layer.enabled: true
                            layer.effect: MultiEffect {
                                brightness: 0.6
                                colorizationColor: "#1affffff" // Change this to your desired color or variable
                                colorization: 1.0 // 1.0 fully tints the image
                                saturation: 0.0 // Adjust saturation if needed
                            }
                        }
                    } 
                }

                Item {
                id: titleContainer
                Layout.fillWidth: true
                Layout.preferredHeight: 25
                clip: true // CRÍTICO: Recorta el texto que se sale de los límites laterales

                // Extraemos el título a una propiedad para mantener el código limpio
                property string trackTitleText: mediaWidget.player && mediaWidget.player.trackTitle !== "" 
                                                ? mediaWidget.player.trackTitle 
                                                : "Desconocido"

                Text {
                    id: scrollText
                    text: titleContainer.trackTitleText
                    color: "#cdd6f4"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    
                    // Lógica de posición: si es más largo empieza en 0, si cabe se centra automáticamente
                    x: contentWidth > titleContainer.width ? 0 : (titleContainer.width - contentWidth) / 2

                    // Propiedad booleana que determina si el texto debe desplazarse
                    readonly property bool shouldScroll: contentWidth > titleContainer.width

                    // Animación que mueve el texto de derecha a izquierda
                    SequentialAnimation on x {
                        id: marqueeAnimation
                        // Se ejecuta solo si el texto desborda Y el reproductor está activo
                        running: scrollText.shouldScroll && mediaWidget.player && mediaWidget.player.isPlaying
                        loops: Animation.Infinite

                        // 1. Pausa inicial antes de empezar a moverse
                        PauseAnimation { duration: 2000 }

                        // 2. Desplazamiento hacia la izquierda
                        NumberAnimation {
                            // Se mueve hasta que el final del texto entra en el contenedor (más un margen de 30px)
                            to: -(scrollText.contentWidth - titleContainer.width) - 30
                            // Duración proporcional a la longitud para mantener una velocidad constante
                            duration: (scrollText.contentWidth - titleContainer.width) * 25 
                            easing.type: Easing.Linear
                        }

                        // 3. Pausa al llegar al final del título
                        PauseAnimation { duration: 2000 }

                        // 4. Regreso suave al inicio
                        NumberAnimation { 
                            to: 0 
                            duration: 1000 
                            easing.type: Easing.InOutQuad 
                        }
                    }

                    // Si cambia la canción, reiniciamos la animación y la posición instantáneamente
                    onTextChanged: {
                        marqueeAnimation.restart()
                        if (!shouldScroll) {
                            x = (titleContainer.width - contentWidth) / 2
                        }
                    }
                }
            }

                // --- BARRA DE PROGRESO ---
                Slider {
                    id: progressBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    // Rango del slider (de 0 a la duración total de la canción)
                    from: 0
                    to: mediaWidget.player && mediaWidget.player.length > 0 ? mediaWidget.player.length : 1

                    // Desactivar si no hay canción o es un stream en vivo (sin longitud)
                    enabled: mediaWidget.player && mediaWidget.player.length > 0

                    Timer {
                        id: progressTimer
                        interval: 1000 // Actualiza cada 1000 ms (1 segundo)

                        // El temporizador funciona siempre que haya un reproductor detectado
                        running: mediaWidget.player !== null
                        repeat: true

                        onTriggered: {
                            // Solo actualizamos la barra si el usuario NO la está arrastrando
                            if (mediaWidget.player && !progressBar.pressed) {
                                progressBar.value = mediaWidget.player.position
                            }
                        }
                    }

                    // Al soltar o arrastrar, enviamos la nueva posición a MPRIS
                    onMoved: {
                        if (mediaWidget.player) {
                            mediaWidget.player.position = progressBar.value
                        }
                    }

                    // (Opcional) Estilización para que encaje con tu diseño Catppuccin/Nord
                    background: Rectangle {
                        x: progressBar.leftPadding
                        y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 6 // Grosor de la barra
                        width: progressBar.availableWidth
                        height: implicitHeight
                        radius: 3
                        color: "#313244" // Fondo oscuro de la pista

                        // La parte "llena" de la barra
                        Rectangle {
                            width: progressBar.visualPosition * parent.width
                            height: parent.height
                            color: "#cdd6f4"
                            radius: 3
                        }
                    }

                    handle: Rectangle {
                        x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
                        y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
                        implicitWidth: 14
                        implicitHeight: 14
                        radius: 7
                        // El "puntito" cambia de color al hacer clic para dar feedback visual
                        color: progressBar.pressed ? "#b4befe" : "#cdd6f4"
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40

                    RowLayout {
                        anchors.fill: parent

                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            // Solo se muestra si hay 2 o más reproductores activos en el sistema
                            visible: mediaWidget.players.length > 1

                            // Efecto hover (Colores Catppuccin)
                            color: cycleMouse.containsMouse ? "#313244" : "transparent"

                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 20
                                // Ícono sugerido (puedes cambiarlo por "media-playlist-repeat" o "view-refresh")
                                source: Quickshell.iconPath("system-switch-user")
                            }

                            MouseArea {
                                id: cycleMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    // Incrementamos el índice. QML detectará el cambio y actualizará
                                    // automáticamente la portada, el título y la barra de progreso.
                                    mediaWidget.currentPlayerIndex += 1
                                }
                            }

                            // (Opcional) Un pequeño tooltip nativo o texto para saber a qué reproductor cambiaste
                            ToolTip.visible: cycleMouse.containsMouse
                            ToolTip.text: mediaWidget.player ? "Cambiando a: " + mediaWidget.player.identity : ""
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#1affffff"
                            radius: this.height / 2
                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 32
                                source: Quickshell.iconPath("media-skip-backward")
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                // Llamamos al método previous() del reproductor
                                onClicked: if (mediaWidget.player) mediaWidget.player.previous()
                            }
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#1affffff"
                            radius: this.height / 2
                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 48
                                source: mediaWidget.player && mediaWidget.player.isPlaying
                                        ? Quickshell.iconPath("media-playback-pause")
                                        : Quickshell.iconPath("media-playback-start")
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                // Llamamos al método playPause() que alterna el estado automáticamente
                                onClicked: if (mediaWidget.player) mediaWidget.player.togglePlaying()
                            }
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#1affffff"
                            radius: this.height / 2
                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 32
                                source: Quickshell.iconPath("media-skip-forward")
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                // Llamamos al método next() del reproductor
                                onClicked: if (mediaWidget.player) mediaWidget.player.next()
                            }
                        }
                    }
                }
            }
        }

        Item {
            visible: !mediaWidget.player
            anchors.fill: parent
            anchors.margins: 20
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 16 // Separación entre el texto y los botones

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: mediaWidget.player ? "Sin portada disponible" : "Nada en reproducción"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.bold: true
                }

                // --- ACCESOS DIRECTOS ---
                // Solo se muestran si de verdad no hay ningún reproductor activo
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16
                    visible: !mediaWidget.player 

                    // --- Botón de Spotify ---
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 12
                        // Efecto hover: cambia de color al pasar el ratón (colores Catppuccin)
                        color: spotifyMouse.containsMouse ? "#313244" : "transparent"

                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: 32
                            // Obtiene el ícono de Spotify directamente de tu tema de íconos del sistema
                            source: Quickshell.iconPath("spotify") 
                        }

                        MouseArea {
                            id: spotifyMouse
                            anchors.fill: parent
                            hoverEnabled: true // Necesario para que containsMouse funcione
                            cursorShape: Qt.PointingHandCursor
                            
                            // Lanza Spotify de forma "desprendida" del widget
                            onClicked: Quickshell.execDetached(["spotify-launcher"])
                        }
                    }

                    // --- Botón de VLC ---
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 12
                        color: vlcMouse.containsMouse ? "#313244" : "transparent"

                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: 32
                            source: Quickshell.iconPath("vlc")
                        }

                        MouseArea {
                            id: vlcMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            // Lanza VLC de forma "desprendida" del widget
                            onClicked: Quickshell.execDetached(["vlc"])
                        }
                    }
                }
            }
        }
        // Texto de respaldo si no hay nada reproduciéndose o falta la portada
        
    }
}