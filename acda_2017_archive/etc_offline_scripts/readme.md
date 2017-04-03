# etc_offline_scripts

All scripts are designed for use within Linux OS (Bash shell) only and are for command line use.

### etcoffline.sh
Automates installation of ETC Expression Offline Editor and conversion between ETC SHW and USITT ASCII file formats directly from the Linux command-line. Requires prior installation of the wine software package, and needs an X11 GUI window to open Expression Offline Editor.

### cue_block_cut.sh
Automates the cropping of library block cues for dance pieces (Cue block 900) into a new file from a raw ETC USITT ASCII (.asc) text formatted file. Requires sed.

### concert_build.sh
Automates cue renumbering for building concert files in USITT ACSII (.asc) text formats. Requires sed.

### end_asc.sh
Adds enddata line to USITT ACSII (.asc) text file. Requires echo.

### git_cloning.sh
Automates local cloning and set up of this and other repositories on github account.

### music_backup.sh
Automates the synchronization/backup of a local directory to a remote server over SSH. Requires rsync.

### tech_block_cut.sh
Automates the cropping of technical information from the dance details submission forms (using the .txt version). Requires sed and grep.

### windows-login.pl
Perl script for RDP remote access into Windows virtual machines.
