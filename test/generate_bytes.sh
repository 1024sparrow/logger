#!/bin/bash
# generate $1 bytes to stdout

for i in $(seq 2 $1)
do
	echo -n x
done
echo
