#!/bin/bash

# Script to install and use the ETC Expression Offline Editor via the Linux Command Line
# NOTE: Needs wine, wget, xsel, and xdotool installed

# Download Variables
etcoffline_weblink="https://www.etcconnect.com/WorkArea/DownloadAsset.aspx?id=10737461562"
etcmanual_weblink="https://www.etcconnect.com/WorkArea/DownloadAsset.aspx?id=10737461005"
zip_file="etc_install.zip"
install_file="Expression_Express_Offline_v311.exe"

# Directory Variables
show_directory="${HOME}/.wine/drive_c/ETC/Eol/Eol311/Shows/"
etc_exec="${HOME}/.wine/drive_c/ETC/Eol/Eol311/winx2.exe"
persedit_exec="${HOME}/.wine/drive_c/ETC/Eol/Eol311/persedit.exe"
etc_exec_directory="${HOME}/.wine/drive_c/ETC/Eol/Eol311/"
etc_directory="${HOME}/.wine/drive_c/ETC"

# File Variables
etcsettings_file=Winx2.ini
shw_template=template.shw
default_shw_output=exp2.shw
default_asc_output=test.asc
ext_shw=shw
ext_ascii=asc

input_file=${2}

macro="9 9"

# FUNCTION: Install Wine and ETC Expression Offline Editor
etc_install() {
	# sanity check: if wine is not installed, error out and exit with output
	wine="$(which wine)";
	
	if [ -z "${wine}" ] ; then
        echo "This script depends on the wine package. Please install wine before running the script.";
		exit 1;
	fi
	echo "${wine}";
	 
	# purge the old ETC editor if needed
	etc_purge;
		
	# download ETC offline editor to /tmp directory
	cd /tmp
	wget ${etcoffline_weblink}
	
	# sanity check: did we download file correctly?
	if [ ! -e "$(basename ${etcoffline_weblink})" ] ; then
        echo "ETC offline editor install file did not download correctly. Please check your Internet connection.";
		exit 1;
	fi
	
	# unzip install file and install ETC offline editor (can we auto-complete install dialogs?)
	mv "$(basename ${etcoffline_weblink})" "${zip_file}"
	unzip ${zip_file};
	wine "${install_file}";

	# wait for installation to occur
	sleep 15;
	
	# copy new ETC settings file Winx2.ini
	etc_reset
	
	# clean up temporary files and shortcuts left by the installation
	rm "${zip_file}"
	rm "${install_file}"
	cd ~
	rm "Expression Off-Line 3.11"
	rm "Expression Off-Line 3.11.lnk"
}
# END FUNCTION

# FUNCTION: Purge ETC Offline Editor from user's .wine directory
etc_purge() {
	
	# sanity check: if ETC offline editor is installed, ask user to confirm deletion (then recursively delete!)
	if [ -e "${etc_exec}" ] ;	then
		echo -n "ETC offline editor is already installed. Do you wish to purge/delete installation (y/n)? "
		read answer
		if echo "$answer" | grep -iq "^n" ; then
			echo "Good thing we asked. Exiting now."
			exit 1;
		else
			rm -Rfv "${etc_directory}";
		fi
	fi
}

# FUNCTION: Replace Winx2.ini file with user defined file or sane defaults
etc_reset() {
	# sanity check: is ETC offline editor installed in user profile
	if [ ! -e "${etc_exec}" ] ; then
        echo "ETC offline editor is not installed in user home directory. Please install first.";
		exit 1;
	fi	
	
	# check if user supplied a Winx2.ini filepath in CLI arguments and cp user supplied file to ETC directory
	if [ ! -z ${input_file} ]; then
          cp ${input_file} ${etc_exec_directory}/${etcsettings_file}
		
	# else replace the Winx2.ini file with new file containing sane defaults (since user cannot right-click window tilebars inside wine processes)!
	else
		echo "[Expression Off-Line]
System Size=10,1
Main=0,0,400,120
Screen 1=637,25,1,1
Screen 2=100,100,1,1
Keypad=803,437,2,1
Faders=433,500,1,1
Submasters=1,378,2,1
Trackpad=1,216,1,1
ASCII Delimiters=1
ASCII Capitalization=3
ASCII Level Format=2
ASCII Manufacturer Specific=1" > ${etc_exec_directory}/${etcsettings_file}
	fi
}

# FUNCTION: Run ETC Offline Editor
etc_run() {
	wine ${etc_exec} &
	sleep 2;
}

# FUNCTION: Exit ETC Offline Editor
etc_exit() {
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key "alt+o" Left Up space space;
}

# FUNCTION: Run ETC Personality Editor
persedit_run() {
	wine ${persedit_exec} &
	sleep 2;
}

# FUNCTION: Open input show file from Show directory
etc_open() {
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key "alt+o" Left Down space;
	sleep 2;
	xdotool search --name "Open" type ${input_shw}; xdotool key Return;
	sleep 2;
}

#FUNCTION: Save ETC show file to Show directory
etc_save() {
	#output_file=${default_shw_output}
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key "alt+o" Left Down Down Down space;
	sleep 1;
	xdotool windowactivate $( xdotool search --name "Save as - Use exp2.shw for floppy") type ${output_file}; xdotool key Return;
	sleep 1;
}

# FUNCTION: Read input USITT ASCII File from Show directory
etc_readascii() {
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key "alt+o" Right space;
	sleep 1;
	xdotool search --name "Read Ascii File" type ${input_asc}; xdotool key Return Return;
	sleep 1;
	xdotool mousemove 650 400 click 3 key a; # right click on ASCII File Status, select all
	#xdotool mousemove 700 1650 click 3 key a; # right click on ASCII File Status, select all (for extended i3 screen)
	xdotool click 3 key c; # right click and copy status text to clipboard
	xdotool mousemove 650 450 click 1; # left click on ASCII File Status OK button
	#xdotool mousemove 700 1700 click 1; # left click on ASCII File Status OK button (for extended i3 screen)
	#xdotool mousemove 700 1500; # move back to etc window
	status="$(xsel --clipboard)"; # paste clipboard to variable status
	sleep 2;
}

# FUNCTION: Write USITT ASCII File to Show directory
etc_writeascii() {
	#output_file=${default_asc_output}
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key "alt+o" Right Down space;
	sleep 1;
	xdotool search --name "Write Ascii File" type ${output_file}; xdotool key Return Return;
	sleep 1;
}

#FUNCTION: Run macro in ETC Editor
etc_macro() {
	xdotool windowactivate $( xdotool search --name "Expression Off-Line" ) key m $macro Return;
	sleep 5;
}


# FUNCTION: Run ETC Offline Editor, load show file defined in CLI arguments, and write to USITT ASCII output file (then exit editor)

# FUNCTION: Run ETC Offline Editor, load template show file, read USITT ASCII output file, run default macro, and save new ETC show file (then exit editor)

# MAIN
case "${1}" in
        clean)
	    rm -i ${show_directory}/*
            ;;
	
        set-template)
		if [ ! -z ${input_file} ]; then
                    # set variables and copy input file
		    cp ${input_file} ${show_directory}/${shw_template};
			    
		else
        	    echo "Please state a filename to set as template shw file";

               fi
                ;;
	
        mv)
	    if [ ! -z ${input_file} ]; then
               mv ${show_directory}/${input_file} .;                
	    else
	       echo "Please state a filename to move out of show directory";
            fi
		;;
	
        run)
	    if [ ! -z ${input_file} ]; then
                # set variables and copy input file
                input_shw=$(basename -a ${input_file})
                cp ${input_file} ${show_directory};
                
                # run etc editor and open file
                etc_run
                etc_open
             
            else
		etc_run
            fi
                ;;

        persedit)
 		persedit_run
                ;;        
        ascii)	    
            # set variables and copy input file	    
            input_shw=$(basename -a ${input_file})

	    # substitute SHW in input file to shw
	    input_file_converted="$(echo ${input_file} | sed 's/SHW/shw/')"

	    output_file=${input_file_converted%.$ext_shw}.$ext_ascii
            cp ${input_file} ${show_directory};
            # run ascii file conversion
            etc_run
            etc_open
            etc_writeascii
            etc_exit
               
            # move output file and clean up
            mv ${show_directory}${output_file} .;
            rm ${show_directory}${input_file};
            ;;
	
        show)
            # set variables and copy input file
            input_shw=$(basename -a ${shw_template})
            input_asc=$(basename -a ${input_file})
    	    output_file=${input_file%.$ext_ascii}.$ext_shw
            cp ${input_file} ${show_directory};
                
            # run show file conversion
            etc_run
            etc_open
            etc_readascii
            etc_macro
            etc_save
            etc_exit
                
            # move output file, clean up, and  create status log file
            mv "${show_directory}${output_file}" .
            rm "${show_directory}${input_file}"
            echo "${status}" > ascii_read_log.txt
            ;;
         
         install)
            # install ETC Offline Editor
            etc_install   
            ;;
                
          purge)
            # purge ETC Offline Editor
            etc_purge 
            ;;
                
          reset)
            # reset ETC Offline Editor settings file
            etc_reset
            ;;
         
        *)
                echo "Please specify:
run [file] = run ETC Expression Offline Editor (and open [file] if specified)
ascii [file.shw] = auto convert SHOW [file] to USITT ASCII format
show [file.asc] = auto convert USIIT ASCII [file] to SHOW format
mv [file] = move file from show directory to pwd
set-template [file] = set [file] as template in show directory
clean = interactively remove files in show directory
persedit = run ETC Personality Editor
-------------------------------------------------------------------
install = downloads and installs ETC Expression Offline Editor (requires wine)
purge = purges ETC Expression Offline Editor from system
reset = resets ETC Expression Offline Editor to sane window defaults
"
                exit 1
                ;;
esac

# EXTRA STUFF
#synclient TouchpadOff=1
#synclient TouchpadOff=0
