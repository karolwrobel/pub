#!/bin/bash

y=`date +%Y`
m=`date +%m`
d=`date +%d`
h=`date +%H`

if [ $h -lt 6 ] && [ $d -gt 1 ]; then
let d--
if [ $d -lt 10 ]		# operacje arytmetyczne na stringu usuwaly wiodace zero
then 				# nalezy je dodac.
d=0$d
fi
fi

sdate=${y}${m}${d}

for i in 18 12 06 00
do

	my_date=${sdate}${i}
	adres="http://new.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=${my_date}&row=406&col=233&lang=pl"

	wget $adres -O /home/ok/Desktop/pogoda_${my_date}.png

	if [ `ls -al /home/ok/Desktop/pogoda_${my_date}.png | cut -f5 -d' '` -gt 10000 ]
	then
		exit
	else
		rm -f /home/ok/Desktop/pogoda_${my_date}.png
	fi
done

