all:
	time (./run.sh)
	time (./run.sh hosts)
	gpicview `ls -1 output/sa*.png| sort -r` &
local:
	time (./run.sh)
	usleep 100000
	gpicview `ls -1 output/sa*.png| sort -r` &
nginx:
	time (./run.sh)
	time (./lib/nginx.sh)
clean:
	rm -f output/*.png output/*.svg output/*.data output/*.d1
	rm -f hosts/*/*.png
show:
	gpicview output/sa*.png &
compress:
	tar czpf copies/load_output.`date +%Y-%m-%d`.tgz output/*


