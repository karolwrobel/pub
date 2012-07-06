#!/bin/bash

# Drukuje temperatury z czujników IBM X60s. Prawdopodobnie będzie działać na innych laptopach Lenovo.
# Sprawdzane na Jądrach 3.3 / 3.4 w Fedorze 16.
# Na centos 5/6 (prawdopodobnie dla jader starszych niż 3.0) najlepszym wyborem jest narzedzie acpitool.

echo "temperatura"
grep [0-9] /sys/devices/platform/thinkpad_hwmon/* 2>/dev/null | awk -F'/' '{ print $NF}' | column -t -s:
