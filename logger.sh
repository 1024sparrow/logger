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
	elif [[ $i == "--generate-config" ]]
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
	sz=$get_size__cache
}

curdir=$(dirname "$log_config_path")
pushd "$curdir" > /dev/null

declare -i sz=0
declare -i log_file_limit=0
declare -i log_files_limit=0
declare -i log_index=1

refresh_config
if [ ! -z $log_file_name_base ]
then
	log_file_name_base=$log_file_name_base.
fi
if [ -d "$log_dir" ]
then
	if [ -f "$log_dir"/last_log_index.txt ]
	then
		log_index=$(cat "$log_dir"/last_log_index.txt)
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

while IFS= read line
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

		echo "$line" >> "$log_dir"/"$log_file_name"
		get_size "$log_dir"/"$log_file_name" "
$line"
		if [ $sz -gt $log_file_limit ]
		then
			log_index+=1
			log_file_name="$log_file_name_base"log.$log_index
		fi
		if [ $log_index -gt $log_files_limit ]
		then
			log_index=1
			log_file_name="$log_file_name_base"log.$log_index
			echo -n "" > "$log_file_name"
			get_size__cache=0
		fi
		echo "$log_index" > "$log_dir"/last_log_index.txt
		echo "$log_file_name" > "$log_dir"/last_log_filename.txt
	fi
#
done

rm $refresh_config__mapped
popd > /dev/null
