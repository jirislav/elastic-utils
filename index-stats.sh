#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 INDEX_NAME STATS_TYPE"
    echo "	STATS_TYPE is optional"
    echo "		Hint: you can specify multiple stats_type or index_name by seperating them by comma"
    echo 
    echo " Available stats_types:"
    echo
    echo "  docs"
    echo "    - The number of docs / deleted docs (docs not yet merged out). Note, affected by refreshing the index."
    echo "  store"
    echo "    - The size of the index. "
    echo "  indexing"
    echo "    - Indexing statistics, can be combined with a comma separated list of types to provide document type level stats."
    echo "  get"
    echo "    - Get statistics, including missing stats."
    echo "  search"
    echo "    - Search statistics. You can include statistics for custom groups by adding an extra groups parameter (search operations can be associated with one or more groups). The groups parameter accepts a comma separated list of group names. Use _all to return statistics for all groups."
    echo "  completion"
    echo "    - Completion suggest statistics. "
    echo "  fielddata"
    echo "    - Fielddata statistics. "
    echo "  flush"
    echo "    - Flush statistics. "
    echo "  merge"
    echo "    - Merge statistics. "
    echo "  request_cache"
    echo "    - Shard request cache statistics. "
    echo "  refresh"
    echo "    - Refresh statistics. "
    echo "  suggest"
    echo "    - Suggest statistics. "
    echo "  warmer"
    echo "    - Warmer statistics. "
    echo "  translog"
    echo "    - Translog statistics. "
    echo 
    echo
}

if [ ! "$1" ]; then
	echo "ERROR:"
	echo "Please provide index name"
	printHelp
	exit 1
fi

if [ ! "$2" ]; then
	statsType=""
else
	statsType="$2"
fi

indexName="$1"

response=`curl -s -XGET "$ELASTIC_URL/$indexName/_stats/$statsType?pretty"`
echo "$response"

exit 0
