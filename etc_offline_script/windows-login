#!/usr/bin/perl -w
use strict;
$ENV{PATH}="/usr/bin:/bin:/sbin:/usr/sbin"; 

my $cmd1 ="/usr/bin/rdesktop"; 

if (defined($ENV{LTSP_CLIENT})) { 
    $cmd1 = "/usr/bin/ltsp-localapps $cmd1";
}
do_rdesktop ($cmd1);
exit 0;

sub do_rdesktop { 
    my $cmd1 = shift @_ || die "no cmd1"; 

   my $u = $ENV{USER};
   my $home = $ENV{HOME};
# print "home is $home\n"; 
   my $winfiles = "$home/WINFILES"; 
   if (!(-e $winfiles)) {
#    print "Creating $winfiles\n"; 
       system ("mkdir $winfiles; chmod 0700 $winfiles");
   }
   
   my $cmd = "$cmd1 -u $u -g 90% -r sound:local ".
       " -r disk:media=\/media,WINFILES=$winfiles ".
       " -r clipboard:CLIPBOARD ".
       " bughead ";
   print "Want to run $cmd\n";
   
   system($cmd);
   return(0);
}

exit 0;


