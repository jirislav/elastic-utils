#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 METRICS"
    echo "	METRICS is optional"
    echo "		Hint: you can specify multiple metrics types by separating them by comma"
    echo
    echo " Available metrics:"
    echo
    echo "  version"
    echo "    - Shows the cluster state version. "
    echo "  master_node"
    echo "    - Shows the elected master_node part of the response "
    echo "  nodes"
    echo "    - Shows the nodes part of the response "
    echo "  routing_table"
    echo "    - Shows the routing_table part of the response. If you supply a comma separated list of indices, the returned output will only contain the indices listed. "
    echo "  metadata"
    echo "    - Shows the metadata part of the response. If you supply a comma separated list of indices, the returned output will only contain the indices listed. "
    echo "  blocks"
    echo "    - Shows the blocks part of the response "
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	metrics=""
else
	metrics="$1"
fi

response=`curl -s -XGET "$ELASTIC_URL/_cluster/state/$metrics?pretty"`
echo "$response"

exit 0
