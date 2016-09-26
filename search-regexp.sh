#!/bin/bash

source utilities.sh

function printHelp() {

cat <<EOF
Usage: $0 [options]

	-i | --index=INDEX			The index to search in
	-d | --document-type=DOCTYPE		The document type to search in (OPTIONAL)
	-m | --match-definition=MATCH_DEF	The document field to search within (you can specify multiple MATCH_DEFS)
	-h | --help				Shows this help message

	See standard regex operators (not much supported):
		https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html#_standard_operators

	Example:
		$0 -i userweb -m "log_message:.*transfermode" -m "origin_method:log[no]{2}..........."
	Explanation:
		Search the userweb index with any document type (not specified) for matches in two fields: log_message & origin_method
			log_message has to match the ".*transfermode", while origin_method the "log[no]{2}..........." regex.

	Note that the regex is very limited & has to match any token from end to end. To learn about tokens, visit:
		https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-tokenizers.html
	
	What token basically means, is the shortest string that can be searched in an index.

EOF

}

function parseArgs() {
	# Setup options parsing
	SHORT="hi:d:m:"
	LONG="help,index:,document-type:match-definition:"
	
	PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
	if [[ $? != 0 ]]; then exit 2; else eval set -- "$PARSED";fi
	
	INDEX=""
	DOCTYPE=""
	MATCH_DEFS=()
	
	while true; do
		case "$1" in
			-h|--help)
				printHelp
				exit 0
				;;
			-i|--index)
				INDEX="$2/"
				shift 2 # past argument
				;;
			-d|--document-type)
				DOCTYPE="$2/"
				shift 2
				;;
			-m|--match-definition)
				MATCH_DEFS+=("$2")
				shift 2
				;;
			--)
				shift
				break
				;;
			*)
				echo "ERROR: Internal error"
				printHelp
				exit 2
				;;
		esac
	done
	
	# handle non-option arguments
	if [[ $# != 0 ]]; then
		echo "ERROR: You specified an non-option argument - there is none"
		printHelp
		exit 2
	fi
}

parseArgs "$@"

if [ ! "$INDEX" ]; then
	echo "ERROR: No index specified"
	exit 1
fi


VALS_TO_HIGHLIGHT=()

FIELDS_REGEX="{"

for MATCH_DEF in "${MATCH_DEFS[@]}"; do
	if [ ! `echo $MATCH_DEF | grep :` ]; then
		echo "ERROR: Wrong MATCH_DEF format!"
		echo 
		echo '	Example MATCH_DEF: "log_message:.*captcha-rpc.*"'
		printHelp
		exit 2
	fi
	# KEY is all at the left side from the colon
	KEY=`echo $MATCH_DEF | cut -d: -f1`

	# VAL is all at the right side from the colon
	VAL=`echo $MATCH_DEF | cut -d: -f2`

	# VAL needs to be lowercased
	# NOTE: if you really need to use uppercase in the query, look for lowercase_expanded_terms setting to false
	VAL="${VAL,,}"

	VALS_TO_HIGHLIGHT+=("$VAL")

	FIELDS_REGEX+=`cat <<EOF
	"$KEY": "${VAL//\"/\"}",
EOF` # Add backslashes in front of doublequotes for VAL

done

# Remove last char
FIELDS_REGEX="${FIELDS_REGEX:0:-1}"
FIELDS_REGEX+="}"

# Remove all newlines
FIELDS_REGEX="${FIELDS_REGEX//$'\n'}"

# Alter backslashes so there are twice as many
FIELDS_REGEX="${FIELDS_REGEX//\\/\\\\}"

# Add backslashes before sed's delimiter if any
FIELDS_REGEX="${FIELDS_REGEX//;/\\;}"

# Build the JSON data query
QUERY="`cat "$DIR/definitions/search-query-regexp.json" | sed "s;FIELDS_REGEX;$FIELDS_REGEX;g"`"

echo
echo "Executing this query:"
echo "curl -s -XGET "$ELASTIC_URL/$INDEX${DOCTYPE}_search?pretty" -d "$QUERY""
echo

# Fire the query to the server!
response=`curl -s -XGET "$ELASTIC_URL/$INDEX${DOCTYPE}_search?pretty" -d "$QUERY"`

# Add highlighting to the response
HIGHLIGHT_EGREP=""
for VAL_TO_HIGHLIGHT in "${VALS_TO_HIGHLIGHT[@]}"; do
	HIGHLIGHT_EGREP+="$VAL_TO_HIGHLIGHT|"
done
HIGHLIGHT_EGREP+="^"

echo
echo "Response:"
echo "$response" | egrep -i "$HIGHLIGHT_EGREP"

if [ "$(echo "$response" | grep hits -A1 | grep total | grep " 0,")" ]; then
	echo
	echo "Found nothing ?"
	echo
	echo "Please refer to the limited regex support in elasticsearch:"
	echo " - https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html"
	echo
	echo "Or also nice explanation on Stack Overflow:"
	echo " - http://stackoverflow.com/questions/25313051/elasticsearch-and-regex-queries#answers-header"
	echo
fi

exit 0

