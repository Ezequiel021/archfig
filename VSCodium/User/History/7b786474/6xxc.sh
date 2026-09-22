#!/bin/bash
raw_nmcli=$(nmcli -t -f ssid,signal,security device wifi list)