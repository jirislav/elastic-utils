#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 INDEX_NAME"
    echo
}

if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide index name"
	printHelp
	exit 1
fi

indexName="$1"

response=`curl -s -XGET "$ELASTIC_URL/$indexName/_settings/?pretty"`
echo "$response"

exit 0
