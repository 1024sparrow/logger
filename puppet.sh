#!/bin/bash

argFormat=""

for i in $*
do
	if [[ $i == "--help" || $i == "-h" ]]
	then
		echo "$(basename $0) [--help]
Pipe puppet (output ll input s is). For performance testing.
Valid arguments:
--help
"
		exit 0
	elif [[ $i =~ -.* ]]
	then
		echo "unsupported key: " $i
		exit 1
	fi
done

while IFS= read line
do
	echo "$line"
done
