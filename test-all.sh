#!/bin/bash

curDir=$(dirname "$0")
pushd "$curDir" > /dev/null

echo "
Testing logger
=============="
if which gzip > /dev/null
then
	echo 'gzip found succesfully'
else
	gzip not found on the system
fi

echo "
Testing logger: testing file writing:
-------------------------------------"
#test/test.sh && tagging/test/test.sh && echo all logger tests passed successfully

pushd test > /dev/null
echo "Testing logger: testing file writing"
if ! ./test.sh
then
	exit 1
fi
popd > /dev/null # test

echo "
Testing logger: testing tag-filter:
-----------------------------------"
pushd tagging/test > /dev/null
if ! ./test.sh
then
	exit 1
fi
popd > /dev/null # tagging/test

echo all logger tests passed successfully

popd > /dev/null
