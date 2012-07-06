
# Sprawdza poziom energii dla baterii w laptopie IBM x60s (pewnie też w innych IBM / Lenovo). 
# Napisany, gdy bateria w związku z jej wiekiem zaczęła wariować. Poziom energii spadał z 70% do 3%, 
# laptop dalej pracował 40 min, poziom dochodził do 0% i w zależności od obciążenia można było z niego korzystać
# jeszcze 10 - 15 min.

# 'cd' mili panstwo jest po to, zeby moc dostac sie do odpowienich plikow po uspieniu i wznowieniu 
# pracy laptopa. Jesli to nastapilo w trakcie dzialania skryptu zaczynal on twierdzic, ze
# nie ma plikow energy_*

# cat /sys/class/power_supply/BAT0/uevent | sed s/POWER_SUPPLY_//g

cd /sys/class/power_supply/BAT0

ile=600
opt=900
pes=300

while true
do

ac_status=`cat status`

# echo Poziom naladowania: `date +%T` $[100*`paste <(cat energy_now) <(cat energy_full) | tr -s ' \t' '/'`] % \
# Status: $ac_status 
# echo Poziom naladowania: `date +%T` $[100*`cat energy_now`/`cat energy_full`] % \


energy_now=`cat energy_now`
energy_full=`cat energy_full`

if [ $energy_now -gt 100 ]
then
echo `date +%T` Poziom naladowania: $[(100*$energy_now)/$energy_full] % \
Status: $ac_status 
else
echo "System straci prad za (`if [ $pes -gt 0 ]; then echo $pes ; else echo -e "\033[01;31mRED ALERT (syncuje ...)\033[01;00m" ; sync ; fi`) - `if [ $ile -gt 0 ]; then echo $ile ; else echo -e "\033[01;31mSMIERC i ZGON! ZDYCHA!" ; fi` - ($opt) sekund"
ile=$[$ile-5]
opt=$[$opt-5]
pes=$[$pes-5]
fi

sleep 5
done

cd - >/dev/null

