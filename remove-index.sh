#!/bin/bash

function printHelp() {
echo 
echo "USAGE: $0 INDEX_NAME"
echo
}

if [ ! "$1" ]; then
	echo "Please provide index name"
	printHelp
	exit 1
fi

indexName="$1"

source config

if [ ! "$ELASTIC_URL" ]; then
	echo "ELASTIC_URL is not set up in config"
	exit 3
fi

curl -XDELETE "$ELASTIC_URL/$indexName/?pretty"
