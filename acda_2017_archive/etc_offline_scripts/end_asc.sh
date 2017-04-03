#!/bin/bash

# Bash script to complete a USITT ASCII file
# NOTE: Needs echo, sed installed

# File and text variables

input_file=${1}
end_data="Enddata"

# check input file exists (exit if not)
#if [ ! -f ${input_file} ]; then
#    /bin/echo "${input_file} not found!";
#    exit 1;

echo ${end_data}
