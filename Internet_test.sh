#!/bin/bash
# Date: 17-02-2016
## THIS SCRIPT FOR CHECKING SEREVER CONNECTED TO THE INTERNET ##

INTERNETOK="$?"

ping -qc 6 4.2.2.2 > /dev/null

## CHECK THE EXSIT STATUS FOR THE PING ##
INTERNETOK="$?"

if [ "$INTERNETOK" -eq 0 ]

then
	## IF EXSIT STATUS IS "0" ##
	echo Internet Connection..OK
	
else
	echo CHECK YOUR INTERNET CONNECTION
fi

#END
