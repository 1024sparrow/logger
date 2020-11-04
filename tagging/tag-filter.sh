#!/bin/bash

# TODO: брать не один файл со списком шаблонов, а произвольное количество файлов со списками шаблонов: для первого тега, для второго и т.д.

for i in $*
do
	if [[ $i == "--help" || $i == "-h" ]]
	then
		echo "SINOPSYS

$(basename $0) [--help] [PATH_TO_FILE_WITH_PASSING_TAGS_TEMPLATES]

OPTIONS:

--help - show this help

PATH_TO_FILE_WITH_PASSING_TAGS_TEMPLATES - one or more filepath-s (with list of filter templates each). First would apply for first word of each line, second - for second & etc.

EXAMPLE:
my-beautiful-server | tag-filter.sh ./tagFileTemplatesFirst ./tagFileTemplatesSecond | insert-datetime.sh | logger.sh ./logger.conf | tag-filter.sh ./tagTtyTemplatesFirst ./tagTtyTemplatesSecond
"
		exit 0
	fi
done

declare -a templates
declare -i iWord

for i in $*
do
	if [[ ! "$i" =~ ^-.* ]]
	then
		tmp=$(sed $i -e "s/*/.*/g")
		templates=("$tmp" "${templates[@]}")
	fi
done

function filter {
	iWord=0
	for i in $1
	do
		if [ $(($iWord+1)) -gt ${#templates[@]} ]
		then
			return 0
		fi
		ok=false
		for iTempl in ${templates[$iWord]}
		do
			if [[ "$i" =~ ^${iTempl}$ ]]
			then
				ok=true
				break
			fi
		done
		if ! $ok
		then
			return 1
		fi
		iWord+=1
	done

	return 0
}

while read line
do
	if filter "$line"
	then
		echo "$line"
	fi
done
