while true ; do 


pidy=`ps aux | grep /usr/lib/flash-plugin/libflashplayer.so | grep -v grep  | awk '{print $2}'`

for id in $pidy
do
 kill $id
done

echo -n '.'

sleep 10

done
