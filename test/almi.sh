#!/bin/bash
# Arbitrary log-message imitator

# $ THIS.sh ModeMain debug
# enter on keyboard: asdasdasd asdasd
# see output: ModeMain debug asdasdasd asdasd
# Press <Ctrl> + <C> to quit

while IFS= read line
do
	echo \<date\> $1 $2 "$line"
done
