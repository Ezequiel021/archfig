#!/bin/bash
for i in $(nmcli -t -f state,device dev status | grep '^connected:' | cut -d: -f2)
    echo $(i)