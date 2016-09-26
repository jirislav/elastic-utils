#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 TASK_ID"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide the TASK_ID to cancel"
	printHelp
	exit 1
fi

taskId="$1"

response=`curl -s -XPOST "$ELASTIC_URL/_tasks/$taskId/_cancel?pretty"`
echo "$response"

exit 0
