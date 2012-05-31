#!/bin/bash


function data_1() {
sar -f "${1}" | grep -viE '^$|LINUX|Średnia:|user.*nice' | sed s/all//g | tr -s ' ' ' ' > "${2}"
}
