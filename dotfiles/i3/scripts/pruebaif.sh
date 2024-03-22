#!/bin/bash

if [ $(whoami) != 'root' ]; then
	echo "You are not root"
else
	echo "You are root"
fi

# $a -lt $b 	$a < $b
# $a -gt $b 	$a > $b
# $a -le $b 	$a <= $b
# $a -ge $b 	$a >= $b
# $a -eq $b 	$a is equal to $b
# $a -ne $b 	$a is not equal to $b
# -e $FILE 	$FILE exists
# -d $FILE 	$FILE exists and is a directory.
# -f $FILE 	$FILE exists and is a regular file.
# -L $FILE 	$FILE exists and is a soft link.
# $STRING1 = $STRING2 	$STRING1 is equal to $STRING2
# $STRING1 != $STRING2 	$STRING1 is not equal to $STRING2
# -z $STRING1 	$STRING1 is empty
