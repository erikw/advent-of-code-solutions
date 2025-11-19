#!/usr/bin/env bash

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS= read -rd '' USAGE <<EOF || :
Clean up empty files like unused output2.0 etc.
Usage: $ ${SCRIPT_NAME} | [-d ]

Options:
-d\t\t Dry run
EOF

# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script

# Arg parsing
arg_dry=false
while getopts ":dh?" opt; do
	case "$opt" in
		d) arg_dry=true;;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

delete_opt=()
[ "$arg_dry" != true ] && delete_opt=(-delete)

find_opts=(
  -path "./2[0-9][0-9][0-9]/*"
  -type f
  -empty
  -print
  "${delete_opt[@]}"
)

find . "${find_opts[@]}"
