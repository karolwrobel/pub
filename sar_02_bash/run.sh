#!/bin/bash

MODE=0

if [ ${1}x == x ]
then
DATA_SRC=/var/log/sa
elif [ ${1}x == "hosts"x ]
then
MODE=1
else
DATA_SRC="${1}"
fi

# lib:			# dostarcza funkcji:
# wybiera strumien wejsciowy, pozbywa sie zbednych danych ze strumienia
. lib/data_1.sh		# data_1(<plik sa..>, <plik *.d1>)
# uzupelnia dane o wartosci 0,00 w odpowiednich przedzialach czasowych
. lib/data_2.sh		# data_2(<plik *.d1>, <plik *.data>)
# generuje wykres z dostarczonych danych
. lib/gnuplot.sh	# plot_data(<plik *.data> <plik wyjsciowy>)

if [ ${MODE} == 0 ] 
then
 for fin in ${DATA_SRC}/sa[0-9][0-9] ; do
 fout="output/" ; fout+=`basename "${fin}"`

	data_1		"${fin}"	"${fout}.d1"
	data_2		"${fout}.d1"	"${fout}.data"
	( plot_data	"${fout}.data"	"${fout}.png" & )
 done 

elif [ ${MODE} == 1 ]
then

 for name in hosts/*/sa[0-9][0-9].data ; do
	( plot_data     "${name}"  "${name/.data/.png}" & )
 done

fi

