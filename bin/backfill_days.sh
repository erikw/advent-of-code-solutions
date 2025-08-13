#!/usr/bin/env bash
# Backfill boilerplate files like README.md, instructions.url etc. for a given year and day.
# NOTE Run this when changing the template in aoc_create_readme()
# NOTE Make sure this script does not call aoc_fetch_input(), as it should not spam curl(1) to AoC server.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS= read -rd '' USAGE <<EOF || :
Backfill boilerplate files like README.md, instructions.url etc for specific or all days. Run this after updating the README.md template.
Usage: $ ${SCRIPT_NAME} -h |[ datefmt ]

Options:
datefmt\t\t yy/d, yy/dd, yyyy/dd. Default: backfill all days.
EOF


backfill_day() {
	local year="$1"
	local day="$2"

	aoc_create_enter "$year" "$day" # Might not exist yet, as compared to backfill_days_all().
	aoc_create_boilerplates "$year" "$day"
	printf "Backfilled %d/%s\n" "$year" "$day" # Print day as %s to preserve leading 0.
}


backfill_days_all() {
	# Regex written to work for both GNU/BSD find meaning e.g. `+` quantifier can't be used.
	paths=$(find . -maxdepth 2 -type d -regex '\./20[0-9][0-9]/[0-9][0-9]*' | sort | sed -e 's|./||')
	for path in $paths; do
		cd "$path" || exit

		IFS="/" read -ra ym <<< "$path"
		year=${ym[0]}
		day=${ym[1]}

		aoc_create_boilerplates "$year" "$day"
		printf "Backfilled %s\n" "$path"
		cd ../..
	done
}


# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script


# Arg parsing
while getopts ":h?" opt; do
	case "$opt" in
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 1 ]; then
	year=$(aoc_parse_year "$@") || exit
	day=$(aoc_parse_day "$@") || exit

	backfill_day "$year" "$day"
else
	backfill_days_all
fi
