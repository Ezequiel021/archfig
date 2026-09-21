#version 300 es
precision mediump float;

// En GLSL ES 3.00, 'varying' cambia a 'in'
in vec2 v_texcoord;

// Definimos el output final de color de forma explícita
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// --- CONTROLES DE CALIBRACIÓN (Modifica estos valores) ---

// 1. Brillo (0.0 es normal. Valores positivos aumentan, negativos oscurecen)
const float BRILLO = -0.0;

// 2. Contraste (1.0 es normal. Valores mayores a 1.0 aumentan el contraste)
const float CONTRASTE = 1.13;

// 3. Saturación (1.0 es normal. 0.0 es blanco y negro. Mayores a 1.0 saturan)
const float SATURACION = 1.0;

// 4. Ganancia / Balance de Blancos (1.0 es normal. Ajusta para corregir tonos dominantes)
const vec3 GANANCIA_RGB = vec3(1.0, 0.97, 0.93); // vec3(Rojo, Verde, Azul)

// --------------------------------------------------------

void main() {
    // 1. Obtener el color original (texture2D cambia a texture)
    vec4 colorOriginal = texture(tex, v_texcoord);
    vec3 color = colorOriginal.rgb;

    // 2. Aplicar Balance de Blancos / Ganancia por canal
    color *= GANANCIA_RGB;

    // 3. Ajustar Brillo
    color += vec3(BRILLO);

    // 4. Ajustar Contraste (punto medio en 0.5)
    color = (color - 0.5) * CONTRASTE + 0.5;

    // 5. Ajustar Saturación usando la luminancia estándar (Luma ITU-R BT.709)
    float luma = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luma), color, SATURACION);

    // 6. Prevenir desbordamiento de rango [0.0, 1.0]
    color = clamp(color, 0.0, 1.0);

    // Asignar al output moderno de fragmentos
    fragColor = vec4(color, colorOriginal.a);
}
