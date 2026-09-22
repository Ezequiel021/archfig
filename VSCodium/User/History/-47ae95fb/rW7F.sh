#!/bin/bash

# Ejecutamos nmcli pidiendo estado, dispositivo, tipo y nombre.
# Filtramos con grep para obtener solo las interfaces conectadas.

while true; do
nmcli -t -f state,device,type,connection dev | grep '^connected:' | awk -F':' '
BEGIN {
    # Iniciamos el arreglo JSON
    printf "[\n"
    first = 1
}
{
    # Si no es el primer elemento, imprimimos una coma para separar los objetos JSON
    if (!first) {
        printf ",\n"
    }
    
    # $1=estado, $2=dispositivo, $3=tipo
    # El nombre de la red empieza en $4. Si el nombre del Wi-Fi tiene dos puntos (ej. "Mi:Red"),
    # awk lo separaría. Este bucle reconstruye el nombre completo de forma segura.
    name = $4
    for (i=5; i<=NF; i++) {
        name = name ":" $i
    }

    # Escapamos posibles comillas dobles en el nombre de la red para no romper el JSON
    gsub(/"/, "\\\"", name)

    # Imprimimos el objeto JSON formateado
    printf "  { \"state\": \"%s\", \"device\": \"%s\", \"type\": \"%s\", \"name\": \"%s\" }", $1, $2, $3, name
    
    first = 0
}
END {
    # Cerramos el arreglo JSON
    printf "\n]\n"
}'

sleep 3
done