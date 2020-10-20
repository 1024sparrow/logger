#!/bin/bash

declare -i sz=0
declare -i log_file_limit=0
declare -i log_files_limit=0
declare -i log_index=1

source logger.conf
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
	source logger.conf
	if $print_to_tty
	then
		echo "$line"
	fi
	if [ ! -z "$log_dir" ]
	then
		log_file_name="$log_file_name_base".log.$log_index
		mkdir -p "$log_dir"

		echo -n "" >> "$log_dir"/"$log_file_name"
		sz=$(ls -l $log_dir/$log_file_name | awk '{print $5}')
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
