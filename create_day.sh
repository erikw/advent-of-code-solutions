#!/usr/bin/env bash
# Usage
# ./create_day.sh
# ./create_day.sh yyyy/dd
# TODO consider using https://github.com/GreenLightning/advent-of-code-downloader next year instead.

FILES=(README.txt part1.rb part2.rb input0)

year=$(date +%Y)
day=$(date +%d)
if [ $# -eq 1 ]; then
	ym="$1"  # format yyyy/dd
	ym_split=(${ym//\// })
	year=${ym_split[0]}
	day=${ym_split[1]}
fi

path=$(date +%Y/day%d)
mkdir -p $path
printf "Created\n%s\n" $path

cd $path
touch ${FILES[@]}

# Input is different per user -- neds login.
#curl -OJs "https://adventofcode.com/${year}/day/${day}/input"

vi -p ${FILES[@]}
