#!/bin/bash

source utilities.sh

function printHelp() {
    echo 
    echo "USAGE: $0"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

response=`curl -s -XGET "$ELASTIC_URL/_nodes/hot_threads?ignore_idle_threads"`
echo "$response"

exit 0
