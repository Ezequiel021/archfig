#!/bin/bash

# 1. Asegurar que se pasó el argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <ruta_de_la_imagen>"
    exit 1
fi

archivo=$(realpath "$1")

# 2. Verificar que el archivo realmente exista en el disco
if [ ! -f "$archivo" ]; then
    echo "Error: El archivo '$archivo' no existe."
    exit 1
fi

# 3. Extraer la extensión y convertirla a minúsculas
extension="${archivo##*.}"
ext_minuscula=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

# 4. Validar la extensión con un condicional 'case'
case "$ext_minuscula" in
    jpg|jpeg|png|gif|webp|bmp)
	;;
    *)
        echo "Error: La extensión .$extension no está permitida."
        echo "Formatos aceptados: jpg, jpeg, png, gif, webp, bmp"
        exit 1
        ;;
esac

matugen image $archivo --prefer=saturation

SYMLINK="$HOME/.config/wallpapers/current_wallpaper"

# 1. Update symlink for persistence across restarts
rm -f "$SYMLINK"
ln -s "$archivo" "$SYMLINK"

# 2. Update hyprpaper instantly in real-time
hyprctl hyprpaper wallpaper ",$SYMLINK"
