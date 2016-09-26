#!/bin/bash

function setupDIR() {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

function loadConfig() {
	
	source "$DIR/config"
	
	if [ ! "$ELASTIC_URL" ]; then
		echo "ELASTIC_URL is not set up in config"
		exit 3
	fi
}

setupDIR
loadConfig
