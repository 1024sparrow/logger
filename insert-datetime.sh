#!/bin/bash

argFormat=""
defaultFormat="%y.%m.%d.%T:%N"

for i in $*
do
	if [[ $i == "--help" || $i == "-h" ]]
	then
		echo "$(basename $0) [--help] [<FORMAT>]
Valid arguments:
--help

FORMAT
	Datetime format.
	\"$defaultFormat\" by default
	See \"man date\" for help for the format.

EXAMPLE:
	$(basename $0) 
"
		exit 0
	elif [[ $i =~ -.* ]]
	then
		echo "unsupported key: " $i
		exit 1
	else
		if [ -z "$argFormat" ]
		then
			argFormat="$i"
		else
			echo "too much arguments. See help for details."
			exit 1
		fi
	fi
done

if [ -z "$argFormat" ]
then
	argFormat="$defaultFormat"
fi

function generate_time_string {
	timestring=$(date +$argFormat)
}

while read line
do
	generate_time_string
	echo "$timestring" "$line"
done
