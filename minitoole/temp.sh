echo "temperatura"
grep [0-9] /sys/devices/platform/thinkpad_hwmon/* 2>/dev/null | awk -F'/' '{ print $NF}' | column -t -s:
