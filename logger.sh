#!/bin/bash

declare -i state=0

for i in $*
do
	if [[ $i == "--help" || $i == "-h" ]]
	then
		echo "$(basename $0) [--help] [--generate-config <FILENAME>] [--config <FILENAME>]
Valid arguments:
--help
--generate-config <FILENAME>
--config <FILENAME>  - use FILENAME as $(basename $0) config

Generate config first. Then change that config (if needed) and use it.
"
		exit 0
	fi
done

for i in $*
do
	[[ $i == "--version" ]] && {
		echo '1.1'
		exit 0
	}
done

for i in $*
do
	if [[ $i == "--generate-config" ]]
	then
		state=1
	elif [[ $i == "--config" ]]
	then
		state=2
	elif [[ $i =~ -.* ]]
	then
		echo "unsupported key: " $i
		exit 1
	else
		if [ $state == 1 ]
		then
			echo "# If you change the logging directory while the logger is running, ensure that the new directory is clean before switching to it.



# This parameters you can change at runtime
#===========================================

# If duplicate to screen
print_to_tty=true

# Directory to store log-files
log_dir=log

# Single log-file size limit (in bytes). If there is log-file greater then (THIS NUMBER OF BYTES) then next logging message would write to next log-file.
log_file_limit=1000000 # 1 MB


# Following parameters MUST NOT be changed at runtime
#=====================================================

# Compress files before saving. Single log-file size is the size before compession.
use_compression=false # NEW! No implemented yet!

# Use datetime as log-file suffix. I.e. use \"log.2021-04-21--20-52-09\" instead of \"log.1\". Old file in this mode will be deleted (and new file created with another name) instead of replaced with new files.
use_datetime_filename_suffix=true


# name template for log-files
# XYZ would get names like XYZ.log.1, XYZ.log.2 & etc.
# empty name template would get names like log.1, log.2 & etc.
log_file_name_base=

# Limit for log-files amount. If that limit reached then new log-files would replace the oldest log-file.
log_files_limit=2000 # for 2 GB of logs at all" > "$i"
			exit 0
		elif [ $state == 2 ]
		then
			log_config_path=$(realpath "$i")
		fi
	fi
done

function getDatetime {
	while IFS=: read -r a b
	do
		[[ $a =~ rtc_time ]] && t="${b// /}"
		[[ $a =~ rtc_date ]] && d="${b// /}"
	done < /proc/driver/rtc
	log_index="$d--${t//:/-}"
}

if [ ! -f "$log_config_path" ]
then
	echo "Please point config file path"
	exit 1
fi

# Starting logging

refresh_config__mapped=$(mktemp)
trap "rm $refresh_config__mapped;echo logger stopped;exit 0" INT # remove temporary file when Ctrl+C
cat "$log_config_path" > $refresh_config__mapped
function refresh_config {
	if [ "$log_config_path" -nt $refresh_config__mapped ]
	then
		cat "$log_config_path" > $refresh_config__mapped
	fi
	source $refresh_config__mapped
}

declare -i get_size__cache=0
get_size__filename=
LANG=C LC_ALL=C
function get_size {
	sz=$get_size__cache
	if [ -z "$2" ]
	then
		get_size__filename="$1"
		get_size__cache=$(ls -l "$1" | awk '{print $5}')
	else
		if [[ "$1" == "$get_size__filename" ]]
		then
			get_size__cache+=${#2}
		else
			get_size__filename="$1"
			get_size__cache=${#2}
		fi
	fi
}

curdir=$(dirname "$log_config_path")
pushd "$curdir" > /dev/null

declare -i sz=0
declare -i log_file_limit=0
declare -i log_files_limit=0

refresh_config
if $use_datetime_filename_suffix
then
	declare log_index
	getDatetime log_index
else
	declare -i log_index=1
fi
if [ ! -z $log_file_name_base ]
then
	log_file_name_base=$log_file_name_base.
fi
tmpTemplate="$log_file_name_base"log.
if [ -d "$log_dir" ]
then
	if $use_datetime_filename_suffix
	then
		tmp=($(ls "$log_dir")) # list of filenames order descending of it's name
		log_index=${tmp[-1]:${#tmpTemplate}}
	else
		if [ -f "$log_dir"/last-log-index.txt ]
		then
			log_index=$(cat "$log_dir"/last-log-index.txt)
		fi
	fi
	if [ -f "$log_dir"/"$log_file_name_base"log.$log_index ]
	then
		get_size "$log_dir"/"$log_file_name_base"log.$log_index
		if [ $sz -gt $log_file_limit ] # this is the oldest log to rewrite (ring logs)
		then
			echo -n "" > "$log_dir"/"$log_file_name_base"log.$log_index
			get_size__cache=0
		fi
	fi
fi

overriding=false
while IFS= read -r line
do
	refresh_config
	if [ ! -z $log_file_name_base ]
	then
		log_file_name_base=$log_file_name_base.
	fi
	if $print_to_tty
	then
		echo "$line"
	fi
	if [ ! -z "$log_dir" ]
	then
		log_file_name="$log_file_name_base"log.$log_index
		if [ ! -d "$log_dir" ]
		then
			mkdir -p "$log_dir"
		fi
		
		overriding=false
		get_size "$log_dir"/"$log_file_name" "
$line"
		if [ $sz -gt $log_file_limit ]
		then
			if $use_datetime_filename_suffix
			then
				getDatetime log_index
			else
				log_index+=1
			fi
			overriding=true
		fi
		if ! $use_datetime_filename_suffix
		then
			if [ $log_index -gt $log_files_limit ]
			then
				log_index=1
				overriding=true
			fi
		fi

		if $overriding
		then
			log_file_name="$log_file_name_base"log.$log_index
			get_size__cache=0
			echo "$line" > "$log_dir"/"$log_file_name"
			get_size "$log_dir"/"$log_file_name" "
$line"
		else
			echo "$line" >> "$log_dir"/"$log_file_name"
		fi
		if ! $use_datetime_filename_suffix
		then
			echo "$log_index" > "$log_dir"/last-log-index.txt
			echo "$log_file_name" > "$log_dir"/last-log-filename.txt
		fi
		if $use_datetime_filename_suffix
		then
			tmp=($(ls "$log_dir"/"$tmpTemplate"* 2>/dev/null)) # list of filenames order descending of it's name
			if [ ${#tmp[@]} -gt $log_files_limit ]
			then
				rm ${tmp[0]}
			fi
		fi
	fi
#
done

rm $refresh_config__mapped
popd > /dev/null
