#!/bin/bash
json_nmcli=$(nmcli -t -f ssid,signal,security device wifi list 2> /dev/null | awk -F':' '
BEGIN {
    printf "["
    first = 1
}
{
    if (!first) { printf "," }
    ssid = $1
    printf "{\"ssid\":\"\%s\",\"signal\":%d,\"security\":\"%s\"}", $1, $2, $3
}
END {
    printf "]"
}\')

echo $json_nmcli

