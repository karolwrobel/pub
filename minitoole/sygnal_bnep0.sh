#!/bin/bash

# zlicza ilosc danych przesylanych na interfejsie ppp0 lub bnep0
# co 1 mb przeslanych danych generuje sygnal dzwiekowy.

# Być może lepiej bylo by zliczac kolejne megabajty od wartosci, ktora
# skrypt zastanie w momencie uruchomienia. 
# Można to rozważać, jako bug, mnie jednak nauczyło pamiętać o uruchamianiu 
# skryptu odpowiednio wczesnie :) 

MY_IFACE="ppp0"
# MY_IFACE="bnep0"

while true ; do ifconfig ${MY_IFACE} | grep -E '.*RX.*TX.*' | cut -d\( -f1 | cut -d: -f2 ; sleep 5 ; done | awk 'BEGIN {a=1000000} {if ($0 > a) { print $0 "WARNING\a" ; a=a+1000000} else {printf $0}}'
