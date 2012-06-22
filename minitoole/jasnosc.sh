aktualna=`cat /sys/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/brightness`


if [ ${1}x != x ]
then
	jasnosc=$1
else
if [ $aktualna -gt 4 ]
then 
	jasnosc=1
else
	jasnosc=5
fi
fi

echo $jasnosc > "/sys/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/brightness"


