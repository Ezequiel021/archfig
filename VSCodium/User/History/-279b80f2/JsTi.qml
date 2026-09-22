pragma Singleton
import QtQuick

QtObject {
    // ==========================================
    // COLORES PRINCIPALES (Acentos)
    // ==========================================
    
    // Primario: El color más destacado, usado para elementos clave (ej. barra de progreso, botón activo).
    property color primary: "#cfbdfe"
    property color onPrimary: "#35275d"
    // Contenedor Primario: Versión más suave del primario, ideal para fondos de widgets activos.
    property color primaryContainer: "#4c3e75"
    property color onPrimaryContainer: "#e8ddff"

    // Secundario: Menos prominente que el primario. Bueno para elementos de soporte o botones secundarios.
    property color secondary: "#cbc2dc"
    property color onSecondary: "#332d41"
    property color secondaryContainer: "#4a4458"
    property color onSecondaryContainer: "#e8def8"

    // Terciario: Se usa para contrastar o crear un balance visual con el primario y secundario.
    property color tertiary: "#efb8c8"
    property color onTertiary: "#4a2532"
    property color tertiaryContainer: "#633b49"
    property color onTertiaryContainer: "#ffd9e3"

    // ==========================================
    // COLORES DE ESTADO (Errores / Alertas)
    // ==========================================
    
    // Error: Usado para indicar fallos, batería muy baja o desconexiones críticas.
    property color error: "#ffb4ab"
    property color onError: "#690005"
    property color errorContainer: "#93000a"
    property color onErrorContainer: "#ffdad6"

    // ==========================================
    // COLORES BASE (Superficies y Fondos)
    // ==========================================
    
    // Background: El fondo general de tu ventana/barra.
    property color background: "#141218"
    property color onBackground: "#e6e1e9"
    
    // Surface: Elementos flotantes como tooltips, menús desplegables o tarjetas.
    property color surface: "#141218"
    property color onSurface: "#e6e1e9"
    
    // Surface Variant: Superficies con un tono ligeramente distinto para diferenciar secciones contiguas.
    property color surfaceVariant: "#49454e"
    property color onSurfaceVariant: "#cac4cf"
    
    // Inverse: Colores invertidos útiles para tooltips o notificaciones de alto contraste tipo "Toast".
    property color inverseSurface: "#e6e1e9"
    property color inverseOnSurface: "#322f35"
    property color inversePrimary: "#64558f"

    // ==========================================
    // BORDES Y LÍNEAS
    // ==========================================
    
    // Outline: Para bordes de botones, separadores o contornos de ventanas.
    property color outline: "#948f99"
    // Outline Variant: Un borde mucho más sutil y mezclado con el fondo.
    property color outlineVariant: "#49454e"
}
