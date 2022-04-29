#!/usr/bin/env sh

# Ref: https://stackoverflow.com/a/69326159/265508
find . -name README.txt -exec printf %c {} + | wc -c | tr -d ' '
