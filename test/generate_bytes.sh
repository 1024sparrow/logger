#!/bin/bash
# generate $1 bytes to stdout
# $2 times (if passed)

declare -i counter=1
if [ ! -z $2 ]
then
	counter=$2
fi

while [ $counter -gt 0 ]
do
	for i in $(seq 2 $1)
	do
		echo -n x
	done
	echo
	counter=$counter-1
done