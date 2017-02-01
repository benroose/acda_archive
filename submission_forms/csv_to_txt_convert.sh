#!/bin/bash

# Script to remove commas from input .csv file and rename output file as .txt
# NOTE: Needs echo, cat and sed installed

# Directory Variables
#show_directory="${HOME}/.wine/drive_c/ETC/Eol/Eol311/Shows/"

# File Variables
ext_csv=csv
ext_text=txt

input_file=${1}
output_file=${input_file%.$ext_csv}.${ext_text}

# check input file exists (exit if not)
if [ ! -f ${input_file} ]; then
    /bin/echo "${input_file} not found!";
    exit 1;

else
	/bin/echo "${input_file} found. Attempting conversion to ${output_file}";
	
	# use sed to transpose commas into a single space globally from input file and redirect as output file
	/bin/echo "AUTOMATED CONVERSION TO TEXT FILE" > ${output_file}
	cat ${input_file} | sed 's/,*,/ /g' >> ${output_file}
	
	# clean up and remove csv input file
	if [ -f ${output_file} ]; then
		/bin/echo "${output_file} successfully generated. Removing original ${input_file}";
		rm ${input_file};
	fi	
fi
