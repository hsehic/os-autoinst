#!/usr/bin/perl -w
use strict;
use bmwqemu;
use Time::HiRes qw(sleep);


if($ENV{MEMTEST}) { # special
	# only run this one
	for(1..6) {
		sendkey "down";
	}
	sleep 3;
	sendkey "ret";
	sleep 6000;
	exit 0; # done
}
# assume bios+grub+anim already waited in start.sh
if(1||$ENV{LIVECD}) {
	# installation (instead of HDDboot on non-live)
	# installation (instead of live):
	sendkey "down";
}
if($ENV{PROMO}) {
	# has extra GNOME-Live and KDE-Live menu entries
	for(1..2) {sendkey "down";}
}

# 1024x768
if($ENV{RES1024}) { # default is 800x600
	sendkey "f3";
	sendkey "down";
	sendkey "ret";
}

sendautotype("nohz=off "); # NOHZ caused errors with 2.6.26
#sendautotype("kiwidebug=1 ");

# set HTTP-source to not use factory-snapshot
if($ENV{NETBOOT}) {
	sendkey "f4";
	sendkey "ret";
	my $mirroraddr="";
	my $mirrorpath="/factory";
	if($ENV{SUSEMIRROR} && $ENV{SUSEMIRROR}=~m{^([a-zA-Z0-9.-]*)(/.*)$}) {
		($mirroraddr,$mirrorpath)=($1,$2);
	}
        #download.opensuse.org
        if($mirroraddr) {
                for(1..22) { sendkey "backspace" }
                sendautotype($mirroraddr);
        }
	sendkey "tab";
	# change dir
	# leave /repo/oss/ (10 chars)
	for(1..10) { sendkey "left"; }
	for(1..22) { sendkey "backspace"; }
	sendautotype($mirrorpath);

        sleep(1.5);
	sendkey "ret";
}

# HTTP-proxy
if($ENV{NETBOOT} && $ENV{HTTPPROXY} && $ENV{HTTPPROXY}=~m/([0-9.]+):(\d+)/) {
	my($proxyhost,$proxyport)=($1,$2);
	sendkey "f4";
	for(1..4) {
		sendkey "down";
	}
	sendkey "ret";
	sendautotype("$proxyhost\t$proxyport\n");
        sleep(1.5);

	# add boot parameters
	# ZYPP... enables proxy caching
	sendautotype("ZYPP_ARIA2C=0"); sleep 2;
}

# German/Deutsch - set last so that above typing will not depend on keyboard layout
if($ENV{INSTLANG} eq "de") {
	sendkey "f2";
	for(1..3) {
		sendkey "up";
	}
	sendkey "ret";
}

# boot
sendkey "ret";

1;
