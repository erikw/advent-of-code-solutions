#!/usr/bin/env bash
# Dependencies: cloc (optional)
# Assumption: a part[1]2.* file means that part is considered solved.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ESC_BOLD="\033[1m"
ESC_REST="\033[0m"

. $SCRIPT_DIR/aoc_lib.sh
aoc_init_script

cloc=false
if [ "$#" -eq 1 ] && [ "$1" = "-c" ]; then
	cloc=true
fi

nbr_solved() {
	local path="./${1:-.}" # Unify so that path always starts with ./, so cut below works.

	# sort -u: account for the fact that a puzzle part can be solved in multiple languages. 
	stars=$(find "$path" -regex '.*/part[12]\.\w+$' -print | cut -d. -f2 | sort -u | wc -l)

	# Day 25 only as part1, part2 for free.
	xmas_day_stars=$(find "$path" -regex '.*/25/part[12]\.\w+$' | cut -d. -f2 | sort -u | wc -l)
	((stars+=$xmas_day_stars))

	echo "$stars"
}

if [ "$cloc" = "true" ]; then
	cloc --quiet --hide-rate --exclude-dir=$(tr '\n' ',' < .clocignore)  --exclude-list-file=.clocignore_files .
	echo
fi

printf "Collected stars per year:\n"
years=$(find . -maxdepth 1 -type d -regex "\./*[0-9]*" | grep -oE "[0-9]+" | sort)
for year in $years; do
	solved=$(nbr_solved $year)
	test $solved = "50" && solved="50 ⭐️"
	printf "%s: %s\n" $year "$solved"
done
printf "===========\n"
printf "Total: ${ESC_BOLD}%d${ESC_REST}\n" $(nbr_solved)
