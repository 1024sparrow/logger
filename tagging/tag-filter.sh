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
"
		exit 0
	fi
done

for i in $*
do
	if [ -z "$tagFilter" ]
	then
		tagFilter="$i"
	else
		echo "unexpected argument. See help."
		exit 1
	fi
done

if [ -z "$tagFilter" ]
then
	echo "file with templates of passing tags not set"
	exit 1
fi

templates=$(sed "$tagFilter" -e "s/*/.*/g")

function filter {
	for i in $templates
	do
		if [[ "$1" =~ ^$i$ ]]
		then
			return 0
		fi
	done
	return 1
}

while read line
do
	if filter "$line"
	then
		echo "$line"
	fi
done


"
my-beautiful-server | tag-filter.sh ./tagFileTemplatesFirst ./tagFileTemplatesSecond | insert-datetime.sh | logger.sh ./logger.conf | tag-filter.sh ./tagTtyTemplatesFirst ./tagTtyTemplatesSecond
"
