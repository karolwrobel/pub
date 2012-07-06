#!/bin/bash

# woot@poczta.pl @ 2012-05 ; v0.2
# 

function data_2() {
#data_set=`basename ${file}`
#dzien=`echo $data_set | tail -c3`

awk '
BEGIN {
	FS=":| "
	f=0
} 

function first(hour,minutes)
{
# to dziala tylko dla danych zbieranych co 10 min
# TODO: wiecej abstrakcji
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

function first_m(hour,minutes,v)
{
# WARN: lepszy period to 4-5 min. Pstwo sie bardziej zgadza.
        if ( minutes >= 59 ) {
        minutes="00"
        hour++
        if (hour<10) {hour="0"hour}
        } else {
        minutes=minutes+v
        if ( minutes < 10 ) {
        minutes="0"minutes
        }
        }
        ret=hour":"minutes":"
        return ret
}

function second(hour,minutes,v)
{
	if ( minutes == 0 ) {
	minutes="59"
        hour--
        if (hour<10) {hour="0"hour}
	} else {
        minutes=minutes-v
	if ( minutes < 10 ) {
        minutes="0"minutes
	}
        }
        ret=hour":"minutes":"
	return ret
}

function check(h,m) 
{
if (m<0) {
h--
m+=60
}
if (m>59) {
h++
m-=60
}
printf h ":" m ":00 "
}

{
if (f==0) 
{prh=$1;prm=$2;f=1;print;next}

str0=first(prh,prm)
str1=$1":"$2":"
# TODO: to porownanie stringow jest lame.
if ( str0 == str1 ) 
{
check($1,$2-3)
for(x=4;x<=NF;x++) {printf $x " "}
print ""
print $0
check($1,$2+3)
#print $3 ""
for(x=4;x<=NF;x++) {printf $x " "}
print ""
} 
else 
{
str0=first_m(prh,prm,4)
printf str0
print "00 0,00 0,00 0,00 0,00 0,00 100,00"
str2=second($1,$2,4)
printf str2
print "00 0,00 0,00 0,00 0,00 0,00 100,00"
print
}
prh=$1 
prm=$2
}' < "${1}" | uniq > "${2}"

# }' | uniq > ${WORKING_DIR}/sa${dzien}.data

}	# data_2 END

