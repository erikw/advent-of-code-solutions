#!/usr/bin/env bash
# Usage
# ./create_day.sh
# ./create_day.sh yy/d
# ./create_day.sh yyyy/dd
# TODO consider using https://github.com/GreenLightning/advent-of-code-downloader next year instead.
#      Or even better https://pypi.org/project/advent-of-code-data/

set -eu

FILES=(README.txt part1.rb input input1.0 output1.0 part2.rb)

enter_today() {
	local year=$1
	local day=$2
	local files_arrayname=$3[@]
	local files=("${!files_arrayname}")

	path="$year/$day"
	mkdir -p $path
	cd "$path"

	touch ${files[@]}
	chmod u+x *.rb
}

fetch_input() {
	local year=$1
	local day=$2

	local url_fmt="https://adventofcode.com/%d/day/%d/input"
	local url="$(printf "$url_fmt" $year $day)"

	if [ -z "${AOC_SESSION+x}" ]; then
		echo -e "\$AOC_SESSION not set.\nMaybe fetch the session cookie value from your browser and put it in to \$XDG_DATA_HOME/secrets.sh" >&2
		exit 2
	fi
	curl --remote-name --remote-header-name --silent --fail --cookie "session=$AOC_SESSION" "$url"
}

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

enter_today $year $day FILES
fetch_input $year $(echo $day | bc)
nvim -p ${FILES[@]}
printf 'git add %s && git commit -m "Add %s" && git push && tig\n' "$path" "$path"
