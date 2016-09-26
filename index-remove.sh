#!/bin/bash

OPTIND=1

source utilities.sh
function printHelp() {
	echo 
	echo "USAGE: $0 INDEX_NAME..."
	echo
	echo "	You can specify more indices as another arguments to remove"
	echo
	echo " Options:"
	echo "		-h	Prints help"
	echo "		-v	Turns verbosity on"
	echo
}

verbose=0

while getopts "h?v" opt; do
	case "$opt" in
	h|\?)
		printHelp
		exit 0
		;;
	v)	verbose=1
		;;
	esac
done


if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide at least one index name"
	printHelp
	exit 1
fi

for indexName in "${@:1}"; do
	echo
	echo "Removing index '$indexName'"

	response=`curl -s -XDELETE "$ELASTIC_URL/$indexName/?pretty"`
	if [ "`echo "$response" | grep status`" ]; then

		statusCode=`echo "$response" | grep status | awk '{print $3}'`

		echo "Server returned $statusCode!"

		if [ $verbose -gt 0 ]; then
			echo "$response"
		fi

	elif [ "`echo "$response" | grep 'acknowledged" : true'`" ]; then
		echo Success!
	else
		echo "Server returned unknown response:"
		echo "$response"
	fi
done

exit 0
