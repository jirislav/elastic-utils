#!/bin/bash

source utilities.sh
function printHelp() {
echo 
echo "USAGE: $0 INDEX_NAME_OLD INDEX_NAME_NEW"
echo
}

if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide old index name"
	printHelp
	exit 1
fi

if [ ! "$2" ]; then
	echo "ERROR:"
	echo "Please provide new index name"
	printHelp
	exit 1
fi

newIndexName="$2"
oldIndexName="$1"

data=`echo '{
	"source": {
		"index": "OLD_INDEX"
	},
	"dest": {
		"index": "NEW_INDEX"
	}
}' | sed "s,OLD_INDEX,$oldIndexName,g" | sed "s,NEW_INDEX,$newIndexName,g"`

echo 
echo "Sending a request to reindex '$oldIndexName' to '$newIndexName' ..."
echo
echo "Response:"
response=`curl -s -XPOST "$ELASTIC_URL/_reindex/?pretty" -d "$data"`
echo "$response"

if [ "`echo "$response" | grep error`" ]; then
	echo
	echo "Failed reindexing the index .. so I will not remove the 'old' index"
	echo
else
	echo
	echo "Deleting old index '$oldIndexName'"
	echo
	echo "Response:"
	response=`curl -s -XDELETE "$ELASTIC_URL/$oldIndexName/?pretty"`
	echo $response
fi

exit 0
