#!/usr/bin/env sh
# Find READMEs that are empty.

git ls-files | grep README.txt | xargs -I {} sh -c 'wc -l {}' | grep "^\s*0\s" | awk '{print $2}'
