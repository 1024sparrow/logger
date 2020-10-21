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
			echo "# Если при работающем логгере меняете директорию логирования, обеспечьте чистоту новой директории, перед тем как на неё переключать

print_to_tty=true
log_dir=1
log_file_name_base=test
log_file_limit=200 # in bytes
log_files_limit=20" > "$i"
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
	source "$log_config_path"
}

curdir=$(dirname "$log_config_path")
pushd "$curdir" > /dev/null

declare -i sz=0
declare -i log_file_limit=0
declare -i log_files_limit=0
declare -i log_index=1

refresh_config
if [ -d "$log_dir" ]
then
	for i in $(seq $log_files_limit)
	do
		if [ ! -a "$log_dir"/"log_file_name_base".log.$i ]
		then
			log_index=$i
			break
		fi
	done
fi

while read line
do
	refresh_config
	if $print_to_tty
	then
		echo "$line"
	fi
	if [ ! -z "$log_dir" ]
	then
		log_file_name="$log_file_name_base".log.$log_index
		mkdir -p "$log_dir"

		echo -n "" >> "$log_dir"/"$log_file_name"
		sz=$(ls -l "$log_dir"/"$log_file_name" | awk '{print $5}')
		if [ $sz -gt $log_file_limit ]
		then
			log_index+=1
		fi
		if [ $log_index -gt $log_files_limit ]
		then
			echo превышен лимит на количество файлов логов.
			log_index=1
			log_file_name="$log_file_name_base".log.$log_index
			echo -n "" > "$log_dir"/"$log_file_name"
		fi
		echo "$line" >> "$log_dir"/"$log_file_name"
		echo "$log_index" > "$log_dir"/last_log_index.txt
		echo "$log_file_name" > "$log_dir"/last_log_filename.txt
	fi
#
done

popd > /dev/null
