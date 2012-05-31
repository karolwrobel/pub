all:
	time (./make.sh)
	gpicview `ls -1 sa*.png| sort -r` &
nginx:
	time (./make.sh )
	time (./make.sh gotonginx )
clean:
	rm -f *.png *.svg *.data
show:
	gpicview sa*.png &
compress:
	tar czpf load.`date +%Y-%m-%d`.tgz sa*


