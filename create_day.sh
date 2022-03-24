#!/usr/bin/env bash
# Usage
# ./create_day.sh
# ./create_day.sh yy/d
# ./create_day.sh yyyy/dd
# TODO consider using https://github.com/GreenLightning/advent-of-code-downloader next year instead.
#      Or even better https://pypi.org/project/advent-of-code-data/

FILES=(README.txt part1.rb part2.rb input0)

year=$(date +%Y)
day=$(date +%d)
if [ $# -eq 1 ]; then
	ym="$1"  # format yyyy/dd
	ym_split=(${ym//\// })
	year=${ym_split[0]}
	day=${ym_split[1]}

	test ${#year} -eq 4  || year="20$year"
	day=$(printf "%02d" $day)
fi

path="$year/$day"
mkdir -p $path
printf 'git add %s && git commit -m "Add %s" && git push\n' "$path" "$path"

cd "$path"
touch ${FILES[@]}
chmod u+x *.rb

# Input is different per user -- neds login.
#curl -OJs "https://adventofcode.com/${year}/day/${day}/input"

nvim -p ${FILES[@]}
