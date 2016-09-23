#!/bin/bash

function printHelp() {
echo 
echo "USAGE: $0 INDEX_NAME MAPPING_TYPE"
echo
}

if [ ! "$1" ]; then
	echo "Please provide index name"
	printHelp
	exit 1
fi

indexName="$1"

if [ ! "$2" ]; then
	echo "Please provide mapping_type name"
	printHelp
	exit 2
fi

source config

if [ ! "$ELASTIC_URL" ]; then
	echo "ELASTIC_URL is not set up in config"
	exit 3
fi

mappingType="$2"

toInsert='
{
  "mappings" : { "'

toAppend='": {
      "properties": {
        "elapsed": {
            "type": "double"
          },                
            "grid": {
            "type": "string"
          },
          "method": {
            "type": "string"
          },
          "pid": {
            "type": "integer"
          },
          "status": {
            "type": "string"
          },
          "url": {
            "type": "string"
        }
      }
    }
  }
}'


data="$toInsert$mappingType$toAppend"

curl -XPUT "$ELASTIC_URL/$indexName/?pretty" -d "$data"
