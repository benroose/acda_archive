#!/bin/bash

# Script to cut and edit school library cue block from USITT ASCII file
# NOTE: Needs echo, cat and sed installed
# designed tobe run using the following command from within submitted_forms directory:
# find */*.txt -print0 | xargs -0 -I {} ../etc_offline_scripts/tech_block_cut.sh {}


# File and text variables
input_file=${1}

# check input file exists (exit if not)
if [ ! -f ${input_file} ]; then
    /bin/echo "${input_file} not found!";
    exit 1;

else
#    /bin/echo "${input_file} found. Attempting technical block cut";

    # use grep and sed to cut technical block from input file and stick in variable
    dance_data=$(cat ${input_file});
    echo "${dance_data}" | grep "College/University" ;
    echo "${dance_data}" | grep "Dance Title" ;

    tech_data=$(echo "${dance_data}" | sed -n "/^ Mid/,/^ OTHER/p" | sed -e 's/^ OTHER TECHNICAL INFORMATION//' -e 's/^ SOFT GOOD STAGE BACKGROUND INFORMATION (select only one)://' -e '/^\s*$/d')

    

    # output to STDOUT
    echo "${tech_data}"
    echo "${dance_data}" | grep -A 5 "Please describe below" | sed -e '/Please describe/d'| sed -e '/^\s*$/d' ;
    echo ""
fi
