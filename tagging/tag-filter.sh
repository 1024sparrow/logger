#!/bin/bash

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

declare -a templateFiles
declare -a templates
declare -a numbers # numbers of templates for each file
declare -i iWord
declare -i iTempl

for i in $*
do
	if [[ ! "$i" =~ ^-.* ]]
	then
		templateFiles=(${templateFiles[@]} "$i")
	fi
done

declare -a tt_0
declare -a tt_1
declare -a tt_2
declare -i tt_count=3

if [[ ${#templateFiles[@]} -ge $tt_count ]]
then
	echo "$(basename $0) supports no greater 3 filtering fields"
	exit 1
fi

function debug {
	echo $* >> ~/1
}

function filter {
	iWord=0
	for i in ${templateFiles[@]}
	do
		#echo "i: \"$i\""
		if [ $iWord -lt $tt_count ]
		then
			if [ $iWord -eq 0 ]
			then
				tt_0=()
				while read -r line
				do
					if [[ ! "$line" =~ ^[[:space:]]*$ ]]
					then
						if [[ ! "$line" =~ ^#.* ]]
						then
							if [[ "$line" == "*" ]]
							then
								line="^.*\$"
							else
								if [[ "${line:0:1}" == "*" ]]
								then
									line="&1${line:1}"
								else
									line="(${line}"
								fi
								if [[ "${line: -1}" == "*" ]]
								then
									line="${line:0:-1}&2"
								else
									line="${line})"
								fi
								line="${line//\./\\.}"
								line="${line//\*/).*(}"
								line="${line/&1/.*(}"
								line="${line/&2/).*}"
								line="^${line}\$"
							fi
							tt_0=("${tt_0[@]}" "$line")
						fi
					fi
				done < "$i"
				#echo "template: ${tt_0[@]}"
			elif [ $iWord -eq 1 ]
			then
				tt_1=()
				while read -r line
				do
					if [[ ! "$line" =~ ^[[:space:]]*$ ]]
					then
						if [[ ! "$line" =~ ^#.* ]]
						then
							if [[ "$line" == "*" ]]
							then
								line="^.*\$"
							else
								if [[ "${line:0:1}" == "*" ]]
								then
									line="&1${line:1}"
								else
									line="(${line}"
								fi
								if [[ "${line: -1}" == "*" ]]
								then
									line="${line:0:-1}&2"
								else
									line="${line})"
								fi
								line="${line//\./\\.}"
								line="${line//\*/).*(}"
								line="${line/&1/.*(}"
								line="${line/&2/).*}"
								line="^${line}\$"
							fi
							tt_1=("${tt_1[@]}" "$line")
						fi
					fi
				done < "$i"
			elif [ $iWord -eq 2 ]
			then
				tt_2=()
				while read -r line
				do
					if [[ ! "$line" =~ ^[[:space:]]*$ ]]
					then
						if [[ ! "$line" =~ ^#.* ]]
						then
							if [[ "$line" == "*" ]]
							then
								line="^.*\$"
							else
								if [[ "${line:0:1}" == "*" ]]
								then
									line="&1${line:1}"
								else
									line="(${line}"
								fi
								if [[ "${line: -1}" == "*" ]]
								then
									line="${line:0:-1}&2"
								else
									line="${line})"
								fi
								line="${line//\./\\.}"
								line="${line//\*/).*(}"
								line="${line/&1/.*(}"
								line="${line/&2/).*}"
								line="^${line}\$"
							fi
							tt_2=("${tt_2[@]}" "$line")
						fi
					fi
				done < "$i"
			fi
			iWord+=1
		fi
	done

	#debug "	#0### ${#tt_0[@]}: \"${tt_0[@]}\""
	#debug "	#1### ${#tt_1[@]}: \"${tt_1[@]}\""
	#debug "	#2### ${#tt_2[@]}: \"${tt_2[@]}\""

	iWord=0
	for i in $1
	do
		if [[ $(($iWord)) -ge ${#templateFiles[@]} ]]
		then
			return 0
		fi
		ok=false
		if [[ $iWord -eq 0 ]]
		then
			iTempl=0
			while [[ ${iTempl} -lt ${#tt_0[@]} ]]
			do
				if [ ! -z "${tt_0[$iTempl]}" ]
				then
					#if [[ "$i" =~ ^${tt_0[$iTempl]}$ ]]
					if [[ "$i" =~ ${tt_0[$iTempl]} ]]
					then
						ok=true
						break
					fi
				fi
				iTempl+=1
			done
		elif [[ $iWord -eq 1 ]]
		then
			iTempl=0
			while [[ ${iTempl} -lt ${#tt_1[@]} ]]
			do
				if [ ! -z "${tt_1[$iTempl]}" ]
				then
					if [[ "$i" =~ ${tt_1[$iTempl]} ]]
					then
						ok=true
						break
					fi
				fi
				iTempl+=1
			done
		elif [[ $iWord -eq 2 ]]
		then
			iTempl=0
			while [[ ${iTempl} -lt ${#tt_2[@]} ]]
			do
				if [ ! -z "${tt_2[$iTempl]}" ]
				then
					if [[ "$i" =~ ${tt_2[$iTempl]} ]]
					then
						ok=true
						break
					fi
				fi
				iTempl+=1
			done
		fi

		if ! $ok
		then
			return 1
		fi

		iWord+=1
	done

	if [ $iWord -lt ${#templateFiles[@]} ]
	then
		return 1
	fi

	return 0
}

while read line1
do
	if filter "$line1"
	then
		echo "$line1"
	#else
	#	echo "## $line1"
	fi
done
