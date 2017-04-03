#!/bin/bash

# Script to cut and edit school library cue block from USITT ASCII file
# NOTE: Needs echo, cat and sed installed

# File and text variables
in_prefix=raw_etc_
out_prefix=cue_block_
ext=asc

input_file=${1}
output_file=${out_prefix}${input_file#*$in_prefix}

dance_piece=${input_file#*$in_prefix}
dance_piece=${dance_piece%*.$ext}
replace_text="LIBRARY CUES"

cue_block="Cue 900"

# check input file exists (exit if not)
if [ ! -f ${input_file} ]; then
    /bin/echo "${input_file} not found!";
    exit 1;

else
    /bin/echo "${input_file} found. Attempting cue block cut to ${output_file}";

    # use sed to cut cue block from input file and stick in variable
    cue_data=$(cat ${input_file} | sed -n "/^${cue_block}/,/^! Groups/p" | sed -e  's/! Groups//');

    # replace cue 900 text with partial filename, name of dance
    cue_data=$(echo "${cue_data}" | sed -e "s/${replace_text}/${dance_piece}/");

    # redirect as output file
#    echo "${cue_data}"
    echo "${cue_data}" > ${output_file}

fi
