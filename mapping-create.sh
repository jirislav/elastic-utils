#!/bin/bash

source utilities.sh

function printHelp() {
	echo 
	echo "USAGE: $0 "
	echo
	echo "	Create mapping in definitions directory with name 'mapping-create-INDEX_NAME.json' so that after this script is executed, the mapping is about to be created in the INDEX_NAME specified in the filename"
	echo
}

for mapping in $(ls $DIR/definitions/mapping-create-*); do

	indexName=`echo $mapping | awk 'BEGIN{FS="definitions/mapping-create-"}{print $2}' | cut -d. -f1`

	data=`cat $mapping`

	# Replace SETTINGS_PLACEHOLDER with real settings defined in settings-create.json
	settings_data=`cat definitions/settings-create.json`
	data="${data/SETTINGS_PLACEHOLDER/$settings_data}"

	echo
	echo "Creating mapping for '$indexName'"

	response=`curl -s -XPUT "$ELASTIC_URL/$indexName/?pretty" -d "$data"`

	if [ "`echo "$response" | grep 'acknowledged" : true'`" ]; then
		echo "Success!"
	else
		echo "Error with response:"
		echo "$response"
	fi
done

exit 0
