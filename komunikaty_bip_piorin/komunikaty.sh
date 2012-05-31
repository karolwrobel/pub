#!/bin/bash

# Karol Wrobel @ 2012
# Sciaga komunikaty o wystepowaniu zagrozen dla upraw rolnych 
# Na stdout drukuje pelna wersje, czyli date pojawienia sie komunikatu 
# i pelen tytul komunikatu. Do pliku 'komunikat.new' stanowiacego podstawe 
# do sporzadzenia wiadomosci sms wysyla przefiltrowany komunikat bez dat.

# SMS plusgsm; 

NRTEL="+48695xxxxxx"
EMAIL="xxx@gmail.com"

if [ ! -f komunikat.new ]; then
touch komunikat.new
fi 

mv komunikat.new komunikat.old

curl 'http://bip.piorin.gov.pl/index.php?pid=1745' | tr '\r' ' ' | grep -E -A5 '<P align=center>[0-9].</P></TD>' | tr '><' '\n\n' | grep -E '[0-9]{2}-|&nbsp' | sed -e s/'&nbsp;'/' '/g | awk '{data=$0; getline; print $0 " " data}' | sed s/\.[:space:]*$//g | tr '\277\363\263\346\352\266\261\274\361' zolcesazn | tee >(sed -e 's/^[0-9]*-[0-9]*-[0-9]* //' -e 's/Komunikat o wystepowaniu //'> komunikat.new)

function smail() {
komunikat_diff=`diff komunikat.old komunikat.new | grep \>`
if [ `echo ${komunikat_diff} | wc -c ` -gt 2 ]
then
	echo Strwierdzono pojawienie sie nowych komunikatow.
	echo "${komunikat_diff}"
	echo Wysylam sms.
	echo "${komunikat_diff}" | mailx -s "komunikat" -r ${EMAIL} ${NRTEL}@text.plusgsm.pl && echo "Sms przekazany do realizacji, Milordzie." || echo "Epic fail, milordzie"
else
	echo '> > Nie stwierdzono pojawienia sie nowych komunikatow od ostatniego sprawdzenia. < <'
fi
}
smail

if [ `wc -l komunikat.new | cut -f1 -d' '` -eq 0 ]
then
	cp -f komunikat.old komunikat.new
fi

