#!/bin/bash

source utilities.sh

function printHelp() {
    echo "
    JSON is great… for computers. Even if it’s pretty-printed, trying to find relationships in the data is tedious. Human eyes, especially when looking at an ssh terminal, need compact and aligned text. The cat API aims to meet this need.
    
    All the cat commands accept a query string parameter help to see all the headers and info they provide."
    echo 
    echo "USAGE: $0 CAT_COMMAND"
    echo "	CAT_COMMAND is optional"
    echo "		Hint: see all cat_commands by running this without argument"
    echo
}

if [[ "$1" =~ "-h" ]] || [[ "$1" =~ "--help" ]]; then
	printHelp
	exit 0
fi

if [ ! "$1" ]; then
	catCommand=""
	echo
	echo "  Available commands are:"
	echo
else
	catCommand="$1"
fi

if [ "`echo $catCommand | grep ?`" ]; then
	glue="&"
else
	glue="?"
fi

result=`curl -s -XGET "$ELASTIC_URL/_cat/${catCommand}${glue}v" | sed 's,/_cat/,,g'`

if [ `echo "$result" | wc -l` -ge 2 ]; then
	echo "$result"
else
	echo
	echo "ERROR:"
	echo "No results found for $catCommand"
	echo
	echo -e " Server answer: \n$result"
	echo
fi
