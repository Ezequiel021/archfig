#!/bin/bash
cnt=1

for i in $(nmcli -t -f state,device dev status | grep '^connected:' | cut -d: -f2)
do
    echo $i $cnt
    ((cnt++))
done