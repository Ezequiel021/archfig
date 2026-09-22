#!/bin/bash
json_nmcli=$(nmcli -t -f ssid,signal,security device wifi list 2> /dev/null awk -F':' -v
'
BEGIN {
    printf "[]"
    first = 1
}
{
    if (!first) { printf "," }
    ssid = $1
    printf "\"ssid\": \"\%s", \"device \""
}


)
'
