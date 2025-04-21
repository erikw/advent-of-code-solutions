#!/usr/bin/env bash

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script

paths=$(find . -maxdepth 2 -type d -regex "\./*[0-9]+/[0-9]+" | sort | sed -e 's|./||')
for path in $paths; do
	cd "$path" || exit
	IFS="/" read -ra ym <<< "$path"
	year=${ym[0]}
	day=${ym[1]}

	aoc_create_readme "$year" "$day"
	printf "Created README.md in %s\n" "$path"
	cd ../..
done