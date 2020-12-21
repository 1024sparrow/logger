#!/bin/bash

testCommands=(
	"rm -rf 1 && ./generate_bytes.sh 20 | ../logger.sh --config test.config" # 1
	"./generate_bytes.sh 190 | ../logger.sh --config test.config" # 2
	"./generate_bytes.sh 190 | ../logger.sh --config test.config" # 3
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 4
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 5
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 6
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 7
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 8
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 9
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 10
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 11
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 12
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 13
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 14
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 15
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 16
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 17
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 18
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 19
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 20
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 21
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 22
	
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 23
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 24
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 25
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 26
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 27
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 28
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 29
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 30
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 31
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 32
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 33
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 34
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 35
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 36
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 37
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 38
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 39
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 40
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 41
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 42
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 43
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 44
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 45
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 46
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 47
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 48
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 49
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 50
	
	"rm -rf 1 && ./generate_bytes.sh 21 5 | ../logger.sh --config test2.config" # 51
	
	"rm -rf 1 && ./generate_bytes.sh 20 | ../logger.sh --config test.config &&
		./generate_bytes.sh 190 2 | ../logger.sh --config test.config &&
		./generate_bytes.sh 6 3 | ../logger.sh --config test.config &&
		./generate_bytes.sh 100 10 | ../logger.sh --config test.config &&
		./generate_bytes.sh 110 6 | ../logger.sh --config test.config" # 52
		
	"./generate_bytes.sh 110 28 | ../logger.sh --config test.config" # 53
)
sizesExpected=(
	"20" # 1
	"210" # 2
	"210 190" # 3
	"210 196" # 4
	"210 202" # 5
	"210 202 6" # 6
	"210 202 106" # 7
	"210 202 206" # 8
	"210 202 206 100" # 9
	"210 202 206 200" # 10
	"210 202 206 300" # 11
	"210 202 206 300 100" # 12
	"210 202 206 300 200" # 13
	"210 202 206 300 300" # 14
	"210 202 206 300 300 100" # 15
	"210 202 206 300 300 200" # 16
	"210 202 206 300 300 310" # 17
	"210 202 206 300 300 310 110" # 18
	"210 202 206 300 300 310 220" # 19
	"210 202 206 300 300 310 220 110" # 20
	"210 202 206 300 300 310 220 220" # 21
	"210 202 206 300 300 310 220 220 110" # 22
	"210 202 206 300 300 310 220 220 220" # 23
	"210 202 206 300 300 310 220 220 220 110" # 24
	"210 202 206 300 300 310 220 220 220 220" # 25
	"210 202 206 300 300 310 220 220 220 220 110" # 26
	"210 202 206 300 300 310 220 220 220 220 220" # 27
	"210 202 206 300 300 310 220 220 220 220 220 110" # 28
	"210 202 206 300 300 310 220 220 220 220 220 220" # 29
	"210 202 206 300 300 310 220 220 220 220 220 220 110" # 30
	"210 202 206 300 300 310 220 220 220 220 220 220 220" # 31
	"210 202 206 300 300 310 220 220 220 220 220 220 220 110" # 32
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220" # 33
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 110" # 34
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220" # 35
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 110" # 36
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220" # 37
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 110" # 38
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220" # 39
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 110" # 40
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220" # 41
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 110" # 42
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220" # 43
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 110" # 44
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 45
	"110 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 46
	"220 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 47
	"220 110 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 48
	"220 220 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 49
	"220 220 110 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 50
	"42   42  21" # 51
	"210 202 206 300 300 310 220 220 110" # 52
	"220 220 110 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 53
#	  1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20
)

last_index_expected=(
	1 # 1
	1 # 2
	2 # 3
	2 # 4
	2 # 5
	3 # 6
	3 # 7
	3 # 8
	4 # 9
	4 # 10
	4 # 11
	5 # 12
	5 # 13
	5 # 14
	6 # 15
	6 # 16
	6 # 17
	7 # 18
	7 # 19
	8 # 10
	8 # 21
	9 # 22
	9 # 23
	10 # 24
	10 # 25
	11 # 26
	11 # 27
	12 # 28
	12 # 29
	13 # 30
	13 # 31
	14 # 32
	14 # 33
	15 # 34
	15 # 35
	16 # 36
	16 # 37
	17 # 38
	17 # 39
	18 # 40
	18 # 41
	19 # 42
	19 # 43
	20 # 44
	20 # 45
	1 # 46
	1 # 47
	2 # 48
	2 # 49
	3 # 50
	3 # 51
	9 # 52
	3 # 53
)

function get_size {
	sz=$(ls -l "$1" | awk '{print $5}')
}

declare -i iCom=0
declare -i iSz=0
declare -i i=0
while [ $iCom -lt ${#testCommands[@]} ]
do
	#echo "test $iCom: ${testCommands[$iCom]}"
	echo -n "test $(($iCom+1))/${#testCommands[@]}: "
	bash -c "${testCommands[$iCom]}"
	iSz=0
	tmp=(${sizesExpected[$iCom]})
	for i in $(seq 20)
	do
		#echo "+${i}+" ${sizesExpected[$i-1]}
		#echo ${tmp[$i-1]}
		if [ -z "${tmp[$i-1]}" ]
		then
			if [ -f 1/test.log.$i ]
			then
				echo failed
				echo "Обнаружен файл 1/test.log.$i. А его быть не должно."
				ls -lh 1
				rm -rf 1
				exit 1
			fi
		else
			if [ ! -f 1/test.log.$i ]
			then
				echo failed
				echo "Не найден файл 1/test.log.$i. Должен быть."
				ls -lh 1
				rm -rf 1
				exit 1
			fi
			get_size 1/test.log.$i
			if [ ! ${tmp[$i-1]} -eq $sz ]
			then
				echo failed
				echo "1/test.log.$i: size $sz instead of expected ${tmp[$i-1]}"
				ls -lh 1
				rm -rf 1
				exit 1
			fi
		fi
	done
	tmp=$(cat 1/last-log-index.txt)
	#echo " ${last_index_expected[$iCom]}-$tmp "
	if [ ! ${last_index_expected[$iCom]} -eq "$tmp" ]
	then
		echo failed
		echo "1/lastindex_expected.txt: \"${last_index_expected[$iCom]}\" expected, \"$tmp\" found"
		ls -lh 1
		rm -rf 1
		exit 1
	fi
	echo ok
	iCom+=1
done
echo "all tests passed"
rm -rf 1
exit 0
