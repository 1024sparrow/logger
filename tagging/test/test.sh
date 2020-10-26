#!/bin/bash

function testPair {
	#echo "$1" -- "$2"
	if [ ! "$1" == "$2" ]
	then
		echo "Test for test \"$1\" failed: \"$2\" expected. \"$1\" taken." # boris here
		return 1
	fi
	return 0
}

src=(
	"qwe"      "qwe"
	"asd"       "asd"
	"wer"       "ert"
)
failed=false
declare -i index=0
for i in "${src[@]}"
do
	if [ $(($index%2)) == 0 ]
	then
		inputMessage="$i"
	else
		outputMessage="$i"
		testPair "$inputMessage" "$outputMessage" || failed=true
	fi
	index+=1
done

if ! $failed
then
	echo "All tests passed"
else
	echo "
Errors occured. Test not passed."
fi
