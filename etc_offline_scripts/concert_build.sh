#!/bin/bash

# Bash script to build the concert USITT ASCII file from cue block files
# NOTE: Needs echo, sed installed

# File and text variables
in_prefix=raw_etc_
out_prefix=cue_block_
ext=asc

input_file=${1}
output_cue_block=${2}
#output_file=${out_prefix}${input_file#*$in_prefix}

max_cues="12"
input_cue_block="900"
let max_lx_cue=input_cue_block+max_cues
input_lx_cue="${input_cue_block}"
output_lx_cue="${output_cue_block}"

interlink_cue_data="   Text INTERLINK
   Up 3
   Down 3
   Chan 5@Hcc 6@Hcc 15@Hff 51@H33 52@H33 53@H33 54@H33 55@H33 56@H33 57@H33
   Chan 58@H33 59@H33 60@H33 61@H33 62@H33 63@H33 64@H33 65@H33 66@H33
   Chan 67@H33 68@H33 69@H33 70@H33 101@Hff 105@Hff 111@Hff 115@Hff 121@Hff
   Chan 125@Hff 131@Hff 135@Hff 141@Hff 145@Hff 151@Hff 155@Hff 161@Hff
   Chan 165@Hff 171@Hff 175@Hff 181@Hff 185@Hff 191@Hff 195@Hff 201@Hff
   Chan 205@Hff 211@Hff 215@Hff
"

# check input file exists (exit if not)
if [ ! -f ${input_file} ]; then
    /bin/echo "${input_file} not found!";
    exit 1;

else
    # pull in input file into variable
    cue_data=$(cat ${input_file})
	       
    #  while loop for cues
    while [ $input_lx_cue -lt $max_lx_cue ]; do

	# use sed to replace input cue number with output cue number for each cue
	cue_data=$(echo "${cue_data}" | sed "s/Cue ${input_lx_cue}/Cue ${output_lx_cue}/");

	let input_lx_cue="input_lx_cue"+1
	let output_lx_cue="output_lx_cue"+1
done 

    # output cue block data
    echo "${cue_data}"
    # echo "${cue_data}" > ${output_file}

    # output interlink cue with correct cue number at end of block
    let output_lx_cue="output_lx_cue"+34
    echo "Cue ${output_lx_cue}"
    echo "${interlink_cue_data}"
fi
