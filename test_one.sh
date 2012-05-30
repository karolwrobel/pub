#!/bin/bash

# HELLO :)

my_name_is=`uname -n`
my_name_is+=" says "
my_name_is+="HELLO WORLD! "
my_name_is+="to "
my_name_is+=`uname -s`
my_name_is+=" community."
echo "${my_name_is}"
