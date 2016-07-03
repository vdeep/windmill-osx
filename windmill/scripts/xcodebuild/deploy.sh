#!/bin/bash

# Requires the following variables to be set
# WINDMILL_BASE_URL
# ACCOUNT
WINDMILL_ROOT="$HOME/.windmill"

set -e

PROJECT_NAME=$1
ACCOUNT=$2
WINDMILL_BASE_URL=$3
(
(

BINARY_LENGTH=$(ls -alF build/$PROJECT_NAME.ipa | cut -d ' ' -f 8)

echo "$WINDMILL_BASE_URL/account/$ACCOUNT/windmill"

LOCATION=$(curl -i -H "binary-length: $BINARY_LENGTH" -F "ipa=@build/$PROJECT_NAME.ipa" -F "plist=@build/manifest.plist" "$WINDMILL_BASE_URL/account/$ACCOUNT/windmill" | awk '/^Location/ {print $2}')

# if_string_is_empty "$LOCATION" exit 1

echo "[windmill] Use $LOCATION for accessing '$PROJECT_NAME'"

) 2>&1 | tee -a "$WINDMILL_ROOT/$PROJECT_NAME.log"
) 2>&1 | tee -a "$WINDMILL_ROOT/windmill.log"