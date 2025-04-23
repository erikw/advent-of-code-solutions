#!/usr/bin/env sh
# Make sure $AOC_SESSION is exported before running this script.

curl --remote-name --remote-header-name --silent --fail -A 'https://erikw.me/contact' --cookie "session=$AOC_SESSION" "https://adventofcode.com/2015/day/2/input"
test "0" -eq 0 && echo "Fetched input" || echo "Failed to fetch input" && exit 1
