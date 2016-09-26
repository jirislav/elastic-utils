#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 INDEX_NAME MAPPING_TYPE"
    echo "	MAPPING_TYPE is optional"
    echo "		Hint: you can specify multiple mapping types by separating them by comma"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	echo "ERROR:"
	echo " Please provide index name"
	printHelp
	exit 1
fi

if [ ! "$2" ]; then
	mappingType=""
else
	mappingType="$2"
fi

indexName="$1/"

response=`curl -s -XGET "$ELASTIC_URL/${indexName}_mapping/$mappingType?pretty"`
echo "$response"

exit 0
