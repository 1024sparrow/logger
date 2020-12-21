#!/bin/bash

function testPair {
	# Arguments:
	# 1 - test message
	# 2 - tag-filter.sh arguments: zero, one or more configs
	# 3 - boolean. If must be passed
	# 4 - name of test (to print note about failure)

#	echo "
#Running test \"$4\"
#" >> ~/1

	realValue=true
	#echo "$1" | ../tag-filter.sh $2
	afterFilterText=$(echo "$1" | ../tag-filter.sh $2)
	#echo "../tag-filter.sh $2"
	if [ -z "$afterFilterText" ]
	then
		realValue=false
	else
		#echo "result string: \"$afterFilterText\""
		echo -n ""
	fi

	if [ ! $realValue == $3 ]
	then
		echo "Test \"$4\" failed."
		return 1
	fi
	return 0
}

# :read !ls test_config
#'
# 10_strong_dot.conf
# 11_strong_star.conf
# 12_strong_dot_star.conf
# 13_boOOs.conf
# 1_allpass.conf
# 2_pass_nothing.conf
# 3_qwe_strong.conf
# 4_qwe_starting.conf
# 5_qwe_end.conf
# 6_qwe_mid.conf
# 7_karl_SOME_son.conf
# 8_boris_olga_karlooo.conf
# 9_dima_vika.conf
#'

src=(
# test name, test message, filter arguments, if pass throw
	'1'     'qwe'       'test_config/1_allpass.conf'          true
	'2'     'asd'       'test_config/1_allpass.conf'          true
	'3'     'wer'       'test_config/2_pass_nothing.conf'     false

	'4'     'qwe'       'test_config/3_qwe_strong.conf'     true
	'4.1'     'qwer'       'test_config/3_qwe_strong.conf'     false
	'4.2'     'qw'       'test_config/3_qwe_strong.conf'     false
	'4.3'     'qwer qwe'       'test_config/3_qwe_strong.conf'     false
	'4.4'     'qwer qwe 4'       'test_config/3_qwe_strong.conf'     false
	'4.5'     'qwe qwe 4'       'test_config/3_qwe_strong.conf'     true
	'4.6'     'qwe qqwe 4'       'test_config/3_qwe_strong.conf'     true
	'4.7'     ' qwe qqwe 4'       'test_config/3_qwe_strong.conf'     true
	'4.8'     '	qwe qqwe 4'       'test_config/3_qwe_strong.conf'     true
	'4.9'     '   qwe qqwe 4'       'test_config/3_qwe_strong.conf'     true

	'5'     'qwer2 4'       'test_config/4_qwe_starting.conf'     true
	'5.1'     '   qwer2 4 56  sdf sdfhh(dd) <%5 $o'       'test_config/4_qwe_starting.conf'     true
	'5.2'     'Sqwer TT'       'test_config/4_qwe_starting.conf'     false
	'5.3'     'qweR TT'       'test_config/4_qwe_starting.conf'     true
	'5.4'     '  qweR TT  '       'test_config/4_qwe_starting.conf'     true
	'5.5'     '  Sqwer TT  '       'test_config/4_qwe_starting.conf'     false

	'6'     'wear_qwe (aa) d'       'test_config/5_qwe_end.conf'     true
	'6.1'     ' sd qwe f'       'test_config/5_qwe_end.conf'     false
	'6.2'     'qwe'       'test_config/5_qwe_end.conf'     true
	'6.3'     'qowe'       'test_config/5_qwe_end.conf'     false
	'6.4'     '  qowe  '       'test_config/5_qwe_end.conf'     false
	'6.5'     '  qwe  '       'test_config/5_qwe_end.conf'     true

	'7'     'asqwe.qwe'       'test_config/6_qwe_mid.conf'     true
	'7.1'     'wer'       'test_config/6_qwe_mid.conf'     false
	'7.2'     '  wer  '       'test_config/6_qwe_mid.conf'     false
	'7.3'     '  asqwe.qwe  '       'test_config/6_qwe_mid.conf'     true

	'8'     'karlson'       'test_config/7_karl_SOME_son.conf'     true
	'8.1'     '  karlson sdf sdf'       'test_config/7_karl_SOME_son.conf'     true
	'8.2'     'karloson'       'test_config/7_karl_SOME_son.conf'     true
	'8.3'     'karlo.son'       'test_config/7_karl_SOME_son.conf'     true
	'8.4'     '  akarloson'       'test_config/7_karl_SOME_son.conf'     false
	'8.5'     '  karloson.'       'test_config/7_karl_SOME_son.conf'     false
	'8.6'     '  akarlosona  '       'test_config/7_karl_SOME_son.conf'     false
	'8.7'     '  karloson  '       'test_config/7_karl_SOME_son.conf'     true

	'9'     'boris q e'       'test_config/8_boris_olga_karlooo.conf'     true
	'9.1'     'olga ddd'       'test_config/8_boris_olga_karlooo.conf'     true
	'9.2'     'karlson'       'test_config/8_boris_olga_karlooo.conf'     true
	'9.3'     'boriska'       'test_config/8_boris_olga_karlooo.conf'     false
	'9.4'     'olgan'       'test_config/8_boris_olga_karlooo.conf'     false
	'9.5'     'kar'       'test_config/8_boris_olga_karlooo.conf'     false
	'9.6'     '  kar  '       'test_config/8_boris_olga_karlooo.conf'     false
	'9.7'     '  karlson  '       'test_config/8_boris_olga_karlooo.conf'     true

	# multi-field filtering (some config-s)
	'10'     'wer'       'test_config/1_allpass.conf test_config/2_pass_nothing.conf'     false
	'10.1'     'wer 456'       'test_config/1_allpass.conf test_config/2_pass_nothing.conf'     false
	'10.2'     'wer 56+ 89+'       'test_config/1_allpass.conf test_config/2_pass_nothing.conf'     false
	'10.3'     'wer 56+ 89+'       'test_config/1_allpass.conf test_config/1_allpass.conf'     true
	'10.4'     '  wer 56+ 89+  '       'test_config/1_allpass.conf test_config/1_allpass.conf'     true
	'10.5'     '  wer 456  '       'test_config/1_allpass.conf test_config/2_pass_nothing.conf'     false

	'11'     'wer 56+ 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.1'     'boris 56+ 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.2'     'boris olga 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.3'     'boris dima 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     true
	'11.4'     ' boris vika wer 56+ 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     true
	'11.5'     ' boris vikar wer 56+ 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.6'     ' boriska vika wer 56+ 89+'       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.7'     '  boriska vika wer 56+ 89+  '       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     false
	'11.8'     '  boris dima 89+  '       'test_config/8_boris_olga_karlooo.conf test_config/9_dima_vika.conf'     true

	# Correct process special symbols ('.' and '*')
	'12'     'boris.ka'       'test_config/10_strong_dot.conf'     true
	'12.1'     'borisaka'       'test_config/10_strong_dot.conf'     false
	'12.2'     'borisaaka'       'test_config/10_strong_dot.conf'     false
	'12.3'     'boriska'       'test_config/10_strong_dot.conf'     false
	'12.4'     '  boris.ka  '       'test_config/10_strong_dot.conf'     true
	'12.5'     '  boriska  '       'test_config/10_strong_dot.conf'     false

	'13'     'boris*ka'       'test_config/11_strong_star.conf'     true
	'13.1'     'boriska'       'test_config/11_strong_star.conf'     true
	'13.2'     'borisaka'       'test_config/11_strong_star.conf'     true
	'13.3'     'boris-boriska'       'test_config/11_strong_star.conf'     true
	'13.4'     'borisa'       'test_config/11_strong_star.conf'     false
	'13.5'     '  borisa  '       'test_config/11_strong_star.conf'     false
	'13.6'     '  boris*ka  '       'test_config/11_strong_star.conf'     true

	'14.1'     'boriska'       'test_config/12_strong_dot_star.conf'     false
	'14.2'     'bori'       'test_config/12_strong_dot_star.conf'     false
	'14.3'     'boris.'       'test_config/12_strong_dot_star.conf'     true
	'14.4'     'boris.i'       'test_config/12_strong_dot_star.conf'     true
	'14.5'     '  bori  '       'test_config/12_strong_dot_star.conf'     false
	'14.6'     '  boris.i  '       'test_config/12_strong_dot_star.conf'     true

	'15'     'boris'       'test_config/13_boOOs.conf'     false
	'15.1'     'borus'       'test_config/13_boOOs.conf'     false
	'15.2'     'bors'       'test_config/13_boOOs.conf'     false
	'15.3'     'bo.is'       'test_config/13_boOOs.conf'     false
	'15.4'     'bo..c'       'test_config/13_boOOs.conf'     false
	'15.5'     'bo..s'       'test_config/13_boOOs.conf'     false
	'15.6'     'bo..sa'       'test_config/13_boOOs.conf'     false
)
failed=false
declare -i index=0
for i in "${src[@]}"
do
	if [ $(($index%4)) == 0 ]
	then
		testName="$i"
	elif [ $(($index%4)) == 1 ]
	then
		inputMessage="$i"
	elif [ $(($index%4)) == 2 ]
	then
		testConf="$i"
	else
		ifShouldPass="$i"
		testPair "$inputMessage" "$testConf" "$ifShouldPass" "$testName" && echo -n "." || failed=true
	fi
	index+=1
done

if ! $failed
then
	echo
	echo "All tests passed"
else
	echo "
Errors occured. Test not passed."
	exit 1
fi
