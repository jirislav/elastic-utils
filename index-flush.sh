#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 INDEX_NAME"
    echo "	INDEX_NAME is optional"
    echo "		Hint: you can specify multiple indices by separating them by comma"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi


if [ ! "$1" ]; then
	indexName=""
else
	indexName="$1/"
fi

response=`curl -s -XPOST "$ELASTIC_URL/${indexName}_flush?pretty"`
echo "$response"

exit 0
