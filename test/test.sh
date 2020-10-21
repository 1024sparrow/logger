#!/bin/bash

testCommands=(
	"rm -rf 1 && ./generate_bytes.sh 20 | ../logger.sh --config test.config" # 0
	"./generate_bytes.sh 190 | ../logger.sh --config test.config" # 1
	"./generate_bytes.sh 190 | ../logger.sh --config test.config" # 2
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 3
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 4
	"./generate_bytes.sh 6 | ../logger.sh --config test.config" # 5
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 6
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 7
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 8
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 9
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 10
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 11
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 12
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 13
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 14
	"./generate_bytes.sh 100 | ../logger.sh --config test.config" # 15
	"./generate_bytes.sh 110 | ../logger.sh --config test.config" # 16
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
)
sizesExpected=(
	"20" # 0
	"210" # 1
	"210 190" # 2
	"210 196" # 3
	"210 202" # 4
	"210 202 6" # 5
	"210 202 106" # 6
	"210 202 206" # 7
	"210 202 206 100" # 8
	"210 202 206 200" # 9
	"210 202 206 300" # 10
	"210 202 206 300 100" # 11
	"210 202 206 300 200" # 12
	"210 202 206 300 300" # 13
	"210 202 206 300 300 100" # 14
	"210 202 206 300 300 200" # 15
	"210 202 206 300 300 310" # 16
	"210 202 206 300 300 310 110" # 17
	"210 202 206 300 300 310 220" # 18
	"210 202 206 300 300 310 220 110" # 19
	"210 202 206 300 300 310 220 220" # 20
	"210 202 206 300 300 310 220 220 110" # 21
	"210 202 206 300 300 310 220 220 220" # 22
	"210 202 206 300 300 310 220 220 220 110" # 23
	"210 202 206 300 300 310 220 220 220 220" # 24
	"210 202 206 300 300 310 220 220 220 220 110" # 25
	"210 202 206 300 300 310 220 220 220 220 220" # 26
	"210 202 206 300 300 310 220 220 220 220 220 110" # 27
	"210 202 206 300 300 310 220 220 220 220 220 220" # 28
	"210 202 206 300 300 310 220 220 220 220 220 220 110" # 29
	"210 202 206 300 300 310 220 220 220 220 220 220 220" # 30
	"210 202 206 300 300 310 220 220 220 220 220 220 220 110" # 31
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220" # 32
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 110" # 33
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220" # 34
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 110" # 35
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220" # 36
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 110" # 37
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220" # 38
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 110" # 39
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220" # 40
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 110" # 41
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220" # 42
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 110" # 43
	"210 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 44
	"110 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 45
	"220 202 206 300 300 310 220 220 220 220 220 220 220 220 220 220 220 220 220 220" # 46
#	  1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20
)

function get_size {
	sz=$(ls -l "$1" | awk '{print $5}')
}

declare -i iCom=0
declare -i iSz=0
declare -i i=0
while [ $iCom -lt ${#testCommands[@]} ]
do
	echo "test $iCom: ${testCommands[$iCom]}"
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
				echo "Обнаружен файл 1/test.log.$i. А его быть не должно."
				exit 1
			fi
		else
			if [ ! -f 1/test.log.$i ]
			then
				echo "Не найден файл 1/test.log.$i. Должен быть."
				exit 1
			fi
			get_size 1/test.log.$i
			if [ ! ${tmp[$i-1]} -eq $sz ]
			then
				echo "1/test.log.$i: size $sz instead of expected ${tmp[$i-1]}"
				exit 1
			fi
		fi
	done
	iCom+=1
done
echo "all tests passed"
exit 0
