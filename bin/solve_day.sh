#!/usr/bin/env bash

set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|t|y|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

IFS= read -rd '' USAGE <<EOF || :
Solve a puzzle day.
Usage: $ ${SCRIPT_NAME} -h | [-l (rb|js|py)] [ datefmt ]

Options:
-l lang\t\t Language to use. Default: rb
datefmt\t\t yy/d, yy/dd, yyyy/dd. Default: today's date.
EOF

declare -A HEADERS
HEADERS[rb]=$(cat <<'HEADER'
#!/usr/bin/env ruby
# frozen_string_literal: true

HEADER
)
HEADERS[js]=$(cat <<'HEADER'
#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

const input = readFileSync(process.argv[2]).toString().trimEnd().split("\n");
HEADER
)
HEADERS[py]=$(cat <<'HEADER'
#!/usr/bin/env python3
import fileinput

def main():
    for line in fileinput.input():
        line = line.rstrip("\n")

if __name__ == '__main__':
	main()	
HEADER
)

enter_day() {
	local year=$1
	local day=$2
	local file_ext=$3
	local files_arrayname=$4[@]
	local files=("${!files_arrayname}")

	path="$year/$day"
	mkdir -p $path
	cd "$path"

	touch "${files[@]}"
	chmod u+x *.${file_ext}
	for f in *.${file_ext}; do
		echo "${HEADERS[$file_ext]}" > $f
	done
}

# Load .env if it exist.
# Ref: https://www.cicoria.com/loading-env-dotenv-using-bash-or-zsh/
load_dotenv() {
	test -f .env || return	
	set -o allexport; source .env; set +o allexport
}

# TODO fetch input1.x from problem description's all <pre><code>...
fetch_input() {
	local year=$1
	local day=$2

	local url_fmt="https://adventofcode.com/%d/day/%d/input"
	local url="$(printf "$url_fmt" $year $day)"

	if [ -z "${AOC_SESSION+x}" ]; then
		printf "\$AOC_SESSION is not set. Fetch the 'session' cookie value from your browser and put it in to .env:\n" >&2
		printf '$ echo AOC_SESSION=value > .env\n' >&2
		exit 2
	fi
	# Include contact method in user agent as requested by @topaz: https://www.reddit.com/r/adventofcode/comments/z9dhtd/please_include_your_contact_info_in_the_useragent/
	curl --remote-name --remote-header-name --silent --fail -A 'https://erikw.me/contact' --cookie "session=$AOC_SESSION" "$url"
}



arg_lang="rb"
while getopts ":l:h?" opt; do
	case "$opt" in
		l) arg_lang="$OPTARG";;
		:) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
		h|?|*) echo -e "$USAGE"; exit 0;;
	esac
done
shift $(($OPTIND - 1))


year=$(date +%Y)
day=$(date +%d)
if [ $# -eq 1 ]; then
	ym=(${1//\// })  # Format: yyyy/dd
	year=${ym[0]}
	day=${ym[1]}

	test ${#year} -eq 4 || year="20$year"
	test ${#day}  -eq 2 || day="0$day"
fi

files=(README.txt input input1.0 output1.0)
files+=("part1.${arg_lang}")
files+=("part2.${arg_lang}")


. $SCRIPT_DIR/lib.sh
cd_git_root
load_dotenv
enter_day $year $day $arg_lang files
fetch_input $year $(echo $day | bc)


if [ "$CODESPACES" = true ]; then
	code part1.${arg_lang} input input1.0 output1.0 part2.${arg_lang} README.md
else
	if [ -n "${TMUX+x}" ]; then
		tmux split-window -h
		tmux last-pane
	fi

	# vim alias not set to nvim, assume $EDITOR is a proper editor (=vi-like).
	$EDITOR -c "tabedit part1.${arg_lang} | sp input | tabedit input1.0 | sp output1.0 | tabedit part2.${arg_lang} | normal 2gt " README.txt
fi


cd_git_root
bin/stats.sh

git status
printf "\n\ngit add %s && git commit -m \"Add %s ${arg_lang}\" && git fetch && git rebase && git push && tig\n" "$path" "$path"
