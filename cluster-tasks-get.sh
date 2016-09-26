#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 ACTIONS"
    echo "	ACTIONS is optional"
    echo "		Hint: you can specify actions by separating them by comma"
    echo
    echo " Example task: cluster:monitor*"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	actions=""
else
	actions="&actions=$1"
fi

response=`curl -s -XGET "$ELASTIC_URL/_tasks?pretty$actions"`
echo "$response"

exit 0
