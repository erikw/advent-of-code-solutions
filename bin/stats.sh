#!/usr/bin/env bash
# Dependencies: cloc (optional)
# Assumption: a part[1]2.* file means that part is considered solved.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ESC_BOLD="\033[1m"
ESC_REST="\033[0m"

IFS= read -rd '' USAGE <<EOF || :
Print AoC statistics.
Usage: $ ${SCRIPT_NAME} -h | [-c]

Options:
-c invoke cloc(1) as well.
EOF

# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script

# Arg parsing
arg_cloc=false
while getopts ":ch?" opt; do
	case "$opt" in
		c) arg_cloc=true;;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

nbr_solved() {
	local year="${1:-}"
	local path="./${year:-}" # Unify so that path always starts with ./, so cut below works.

	# sort -u: account for the fact that a puzzle part can be solved in multiple languages.
	# Regex written to work for both GNU/BSD find meaning e.g. `+` quantifier can't be used.
	stars=$(find "$path" -iregex '.*/part[12]\.[a-z][a-z]*$' -print | cut -d. -f2 | sort -u | wc -l)

	# Day 25 only as part1, part2 for free.
	# TODO update this to check day12 instead if $year>=2025. Rename to stars_last_day
	stars_d25=$(find "$path" -iregex '.*/25/part1\.[a-z][a-z]*$' | cut -d. -f2 | sort -u | wc -l)
	((stars+=stars_d25))

	echo "$stars"
}

if [ "$arg_cloc" = true ]; then
	cloc --quiet --hide-rate --exclude-dir="$(tr '\n' ',' < .clocignore)" --exclude-list-file=.clocignore_files .
	echo
fi

printf "🎅 Collected stars per year:\n"
years=$(find . -maxdepth 1 -type d -regex "\./*[0-9]*" | grep -oE "[0-9]+" | sort)
for year in $years; do
	solved=$(nbr_solved "$year")
	test "$solved" = "50" && solved="50 ⭐️"
	printf "%s: %s\n" "$year" "$solved"
done
printf "===========\n"
printf "Total: ${ESC_BOLD}%d${ESC_REST}\n" "$(nbr_solved)"
