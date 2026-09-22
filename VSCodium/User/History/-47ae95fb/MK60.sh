#!/bin/bash
for i in $(nmcli -t -f state,device dev status | grep '^connected:' | cut -d: -f2)

cnt=1
do
    echo $i $cnt
    ((cnt++))
done