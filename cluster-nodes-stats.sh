#!/bin/bash

source utilities.sh
function printHelp() {
    echo 
    echo "USAGE: $0 STATS"
    echo "	STATS is optional"
    echo "		Hint: you can specify multiple stats types by separating them by comma"
    echo
    echo " Available stats:"
    echo
    echo "  indices"
    echo "    - Indices stats about size, document count, indexing and deletion times, search times, field cache size, merges and flushes"
    echo "  fs"
    echo "    - File system information, data path, free disk space, read/write stats (see FS information)"
    echo "  http"
    echo "    - HTTP connection information"
    echo "  jvm"
    echo "    - JVM stats, memory pool information, garbage collection, buffer pools, number of loaded/unloaded classes"
    echo "  os"
    echo "    - Operating system stats, load average, mem, swap (see OS statistics)"
    echo "  process"
    echo "    - Process statistics, memory consumption, cpu usage, open file descriptors (see Process statistics)"
    echo "  thread_pool"
    echo "    - Statistics about each thread pool, including current size, queue and rejected tasks"
    echo "  transport"
    echo "    - Transport statistics about sent and received bytes in cluster communication"
    echo "  breaker"
    echo "    - Statistics about the field data circuit breaker "
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	stats=""
else
	stats="$1"
fi

response=`curl -s -XGET "$ELASTIC_URL/_nodes/stats/$stats?pretty"`
echo "$response"

exit 0
