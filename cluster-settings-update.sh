#!/bin/bash

source utilities.sh

clusterDefinition="$DIR/definitions/cluster-settings.json"

function printHelp() {
    echo 
    echo "USAGE: $0"
    echo
    echo "	Takes the cluster settings from file '$clusterDefinition'"
    echo "	 - see https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

# data=`cat $clusterDefinition | sed "s,MAPPING_TYPE,$clusterType,g"`
data=`cat "$clusterDefinition"`

response=`curl -s -XPUT "$ELASTIC_URL/_cluster/settings?pretty" -d "$data"`
echo "$response"

exit 0
