#!/bin/bash

# woot@poczta.pl @ 2012-05 ; v0.1
# 
# Krotki opis:
# Tworzy statystyki na podstawie wypluwanych przez polecenie sar danych. Dostosowuje format danych 
# do akceptowalnego przez program gnuplot. Za pomoca gnuplot tworzony jest wykres i zapisywany w postaci 
# pliku graficznego w formacie PNG. 
# 
# Skrypt zaklada, ze pliki z danymi zgromaczone sa w katalogu /var/log/sa/ z nazwa pliku w formacie: sa[0-9][0-9]
# 
# W pliku BUG.txt znajduje sie spis rozpoznanych niedogodnosci.
# 
# PS: Skrypt napisany dla przypomnienia kilku cech AWK. Mozna napisac go bardziej optymalnie, 
# o wiele tresciwiej.  

for file in /var/log/sa/sa[0-9][0-9] ; do

data_set=`basename ${file}`
dzien=`echo $data_set | tail -c3`


sar -f ${file} | awk '
# Usowa zbedne linie.
# WARN: flaga nie potrzebna, skoro spradzany jest warunek czy $4 ma cyfre
# to samo, co: grep -vE CPU|^$|Average
BEGIN {
	flaga=-2
} 
{ 
	if (NF<3) 
	{flaga++; next
	}
	if ($1 ~ /Linux/ || $1 ~ /Average/ || $1 ~ /Średnia:/ || $4 !~ /[0-9]/) 
	{next
	}
	if (!flaga) 
	{exit
	}
	print 
}
' | tr -s ' ' ' ' | awk '
# Usowa zbedne kolumny. WARN: Mozna wrzucic wyzej (bedzie szybciej), 
# ale niech kazdy blok robi jedno (bedzie czytelniej).
	{ for(i=1;i<=NF;i++) 
	{ if ($i ~ /[0-9]/) 
	{printf $i " "} 
	}
	print ""
}' | awk '
# Wstawia dwa wiersze z wartosciami 0.00 w kolumnach z danymi.
# Jeden wiersz w minute po ostatnim wpisie, drugi w minute 
# przed nastepnym.
# WARN: paczaj BUG.txt
BEGIN {
	FS=":"
	f=0
} 

function first(hour,minutes)
{
	if ( minutes > 49 ) {
	minutes="00"
	hour++
	if (hour<10) {hour="0"hour}
	} else {
	minutes=minutes+10
	}
	ret=hour":"minutes":"
	return ret
}

function first_m(hour,minutes)
{
# WARN: lepszy period to 4-5 min. Pstwo sie bardziej zgadza.
# poza tym mozliwe, ze bedziemy odporni na problem opoznien sara (BUG.txt)
        if ( minutes >= 59 ) {
        minutes="00"
        hour++
        if (hour<10) {hour="0"hour}
        } else {
        minutes=minutes+1
        if ( minutes < 10 ) {
        minutes="0"minutes
        }
        }
        ret=hour":"minutes":"
        return ret
}

function second(hour,minutes)
{
	if ( minutes == 0 ) {
	minutes="59"
        hour--
        if (hour<10) {hour="0"hour}
	} else {
        minutes=minutes-1
	if ( minutes < 10 ) {
        minutes="0"minutes
	}
        }
        ret=hour":"minutes":"
	return ret
}
{
if (f==0) 
{prh=$1;prm=$2;f=1;next}

str0=first(prh,prm)
str1=$1":"$2":"
# to porownanie stringow jest lame. Wartosci liczbowe sa bardziej elastyczne.
if ( str0 == str1 ) 
{print
} 
else 
{
str0=first_m(prh,prm)
printf str0
print "00 0,00 0,00 0,00 0,00 0,00 100,00"
str2=second($1,$2)
printf str2
print "00 0,00 0,00 0,00 0,00 0,00 100,00"
print
}
prh=$1 
prm=$2
}' | uniq > sa${dzien}.data


# wysyla niezbedne dane do programu gnuplot.
cat << EOF | gnuplot 
set terminal png size 1000,600
set xdata time
set timefmt "%H:%M:%S"
set output "${data_set}.png"
set xrange ["00:00:00":"23:59:59"]
set yrange [0:100]
set grid
set xlabel "Data / Czas"
set ylabel "Obciążenie"
set title "`hostname` Obciążenie średnie CPU (`lscpu | grep ^CPU\(s\) | tr -s ' ' ' ' | cut -f2 -d' '` core) ${dzien} MAJ"
set key left box
plot "sa${dzien}.data" using 1:2 index 0 title "%user" with lines lt rgb "#FF0000", \
     "sa${dzien}.data" using 1:3 index 0 title "%nice" with lines, \
     "sa${dzien}.data" using 1:4 index 0 title "%system" with lines, \
     "sa${dzien}.data" using 1:5 index 0 title "%iowait" with lines, \
     "sa${dzien}.data" using 1:(\$2+\$3+\$4+\$5) index 0 title "SUMA" with points lt -1, \
     "sa${dzien}.data" using 1:(100-\$7) index 0 title "100-%idle" with points lt 0
EOF
# set terminal png size 1200,800
# set terminal svg size 1280,800 # (w tym przypadku rozdzielczosc wplywa na wielkosc czcionki opisu)
# "sa${dzien}.data" using 1:6 index 0 title "%steel" with lines, \

done

function generate_html() {
cat << EOF
<html>
EOF

mypwd=${PWD}
cd /usr/share/nginx/html/sar

for i in *.png ; do
cat << EOF
<img src="$i">
EOF
done

cd ${mypwd}

cat << EOF
</html>
EOF
}

function nginx_html() {
HTML="/usr/share/nginx/html/sar/index.html"
cp -f *.png /usr/share/nginx/html/sar/
generate_html > ${HTML}
}

if [ ${1}x == "gotonginx"x ]
then
nginx_html
fi
