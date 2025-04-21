#!/usr/bin/env bash
# TODO run shellcheck on all bin/*.sh
# TODO add shellcheck github action. use -x flag for shellcheck  to follow sources. Same for templates repo
# TODO add bin/ to PATH in CODESPACES

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IFS= read -rd '' USAGE <<EOF || :
Solve a puzzle day.
Usage: $ ${SCRIPT_NAME} -h | [-l (rb|js|py)] [ datefmt ]

Options:
-l lang\t\t Language to use. Default: rb
datefmt\t\t yy/d, yy/dd, yyyy/dd. Default: today's date.
EOF

declare -A TEMPLATE
TEMPLATE[rb]=$(cat <<'TEMPLATE'
#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines.map { |l| l.chomp.split }
TEMPLATE
)
TEMPLATE[js]=$(cat <<'TEMPLATE'
#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

const input = readFileSync(process.argv[2]).toString().trimEnd().split("\n");
TEMPLATE
)
TEMPLATE[py]=$(cat <<'TEMPLATE'
#!/usr/bin/env python3
import fileinput
from pprint import pprint

def main():
    for line in fileinput.input():
        line = line.rstrip("\n")

if __name__ == '__main__':
	main()
TEMPLATE
)

# Prepare directory and files for day, and cd into the directory.
enter_day() {
	local year="$1"
	local day="$2"
	local file_ext="$3"

	local files=(input1.0 output1.0 output2.0)
	files+=("part1.${arg_lang}")
	files+=("part2.${arg_lang}")

	aoc_create_enter "$year" "$day"

	touch "${files[@]}"
	chmod u+x ./*."${file_ext}"
	echo "${TEMPLATE[$file_ext]}" > part1."${file_ext}"


	aoc_fetch_input "$year" "$day"
	aoc_create_readme "$year" "$day"
}


# shellcheck source=bin/aoc_lib.sh
. "$SCRIPT_DIR/aoc_lib.sh"
aoc_init_script

# Arg parsing
arg_lang="${AOC_LANG:-rb}" # Can be set in .env or in shell env.
while getopts ":l:h?" opt; do
	case "$opt" in
		l) arg_lang="$OPTARG";;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $((OPTIND - 1))

year=$(aoc_parse_year "$@")
day=$(aoc_parse_day "$@")

enter_day "$year" "$day" "$arg_lang"


if [ "$CODESPACES" = true ]; then
	code part1."${arg_lang}" input1.0 output1.0 input output2.0 part2."${arg_lang}"
	$SHELL # Spawn subshell in 20yy/mm
else
	if [ -n "${TMUX+x}" ]; then
		tmux split-window -h
		tmux last-pane
	fi

	# vim alias not set to nvim, assume $EDITOR is a proper editor (=vi-like).
	$EDITOR -c "sp input | tabedit input1.0 | sp output1.0 | tabedit part2.${arg_lang} | normal 2gt " part1."${arg_lang}"
fi


aoc_cd_git_root # Get back again, to run git commands etc.
"$SCRIPT_DIR"/stats.sh
git status
printf "\n\ngit add %s && git commit -m \"Add %s ${arg_lang}\" && git fetch && git rebase && git push && tig\n" "$path" "$path"