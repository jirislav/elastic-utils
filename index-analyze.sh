#!/bin/bash

source utilities.sh
function printHelp() {
echo 
echo "USAGE: $0 INDEX_NAME ANALYZER TEXT_TO_ANALYZE"
echo
}

if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide index name"
	printHelp
	exit 1
fi

if [ ! "$2" ]; then
	echo "ERROR:"
	echo "Please provide analyzer name"
	printHelp
	exit 2
fi

if [ ! "$3" ]; then
	echo "ERROR:"
	echo "Please provide text to analyze"
	printHelp
	exit 2
fi

indexName="$1"
analyzer="$2"
text="$3"

data=`echo '{
  "analyzer": "ANALYZER",
  "text": "TEXT"
}' | sed "s,TEXT,${text/,/\\,},g" | sed "s,ANALYZER,$analyzer,g"`

echo "$data"

response=`curl -s -XPOST "$ELASTIC_URL/$indexName/_analyze?pretty" -d "$data"`
echo "$response"

exit 0
