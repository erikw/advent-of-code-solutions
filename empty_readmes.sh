#!/usr/bin/env sh
# Find README.s that are empty.

git ls-files | grep README.txt | xargs -I {} sh -c 'wc -l {}' | grep "^\s*0\s" | awk '{print $2}'
