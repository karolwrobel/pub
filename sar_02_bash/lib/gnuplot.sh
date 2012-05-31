#!/bin/bash

function plot_data() {

echo -e "\trysuje $2"

cat << EOF | gnuplot 
set terminal png size 1000,600
set xdata time
set timefmt "%H:%M:%S"
set output "${2}"
set xrange ["00:00:00":"23:59:59"]
set yrange [0:100]
set grid
set xlabel "Data / Czas"
set ylabel "Obciążenie"
set title "`hostname` Obciążenie CPU (`lscpu | grep ^CPU: | tr -s ' ' ' ' | cut -f2 -d' '` core) dane: ${1}"
set key left box
plot "${1}" using 1:2 index 0 title "%user" with lines lt rgb "#FF0000", \
     "${1}" using 1:3 index 0 title "%nice" with lines, \
     "${1}" using 1:4 index 0 title "%system" with lines, \
     "${1}" using 1:5 index 0 title "%iowait" with lines, \
     "${1}" using 1:(\$2+\$3+\$4+\$5) index 0 title "SUMA" with points lt -1, \
     "${1}" using 1:(100-\$7) index 0 title "100-%idle" with points lt 0
EOF
}
