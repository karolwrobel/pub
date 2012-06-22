#!/bin/bash

# ok@2012

old=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

case "$old" in
	performance)	freq="ondemand"
	;;
	ondemand)	freq="powersave"
	;;
	powersave)	freq="performance"
	;;
	*)	
	;;
esac

echo "$old -> $freq"

for i in 0 1; do
echo "$freq" > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor
done

