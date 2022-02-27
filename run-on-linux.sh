#!/bin/bash

REPO_NAME=easy-ddos
ACTUAL_TAG=0.1.0

# from branch: URL="https://github.com/julfy/$REPO_NAME/archive/refs/heads/$ACTUAL_TAG.zip"
URL="https://github.com/julfy/$REPO_NAME/archive/refs/tags/$ACTUAL_TAG.zip"

# Install docker
if [[ -z "$(which docker)" ]]; then
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
	rm get-docker.sh
fi
sudo systemctl start docker

# Download
curl -L --output "$ACTUAL_TAG.zip" "$URL"
# or wget -q "$URL"

# Extract
unzip -o "$ACTUAL_TAG.zip"
rm -rf "$REPO_NAME"
mv "$REPO_NAME-$ACTUAL_TAG" "$REPO_NAME"

# Cleanup
rm "$ACTUAL_TAG.zip"

# TODO: Select random/all targets 

# Build docker image
cd "$REPO_NAME"
sudo docker build --no-cache --tag $REPO_NAME .

# Start
echo ""
echo "Starting attack on targets: "
cat targets.txt
echo ""
CONTAINER_ID=$(sudo docker run -d "$REPO_NAME")

# Wait for input
read -n 1 -p "Press any key to stop"
echo " Stopping..."

# Stop
sudo docker rm $(sudo docker stop $CONTAINER_ID) > /dev/null

echo 'Stopped.'
