#!/usr/bin/env bash
# Fetch input file to a given year and day.

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS= read -rd '' USAGE <<EOF || :
Fetch input for a given year and day.
Usage: $ ${SCRIPT_NAME} -h | [ datefmt ]

Options:
datefmt\t\t yy/d, yy/dd, yyyy/dd. Default: today's date.
EOF


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

year=$(aoc_parse_year "$@") || exit
day=$(aoc_parse_day "$@") || exit

aoc_create_enter "$year" "$day"
aoc_fetch_input "$year" "$day"
printf "Fetched %d/%s/input\n" "$year" "$day" # Print day as %s to preserve leading 0.