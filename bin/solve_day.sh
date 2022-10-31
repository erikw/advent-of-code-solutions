#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" =~ ^1|true|yes$ ]] && set -o xtrace

SCRIPT_NAME=${0##*/}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

IFS= read -rd '' USAGE <<EOF || :
Solve a puzzle day.
Usage: $ ${SCRIPT_NAME} -h | [-l (rb|js)] [ datefmt ]

Options:
datefmt\t\t yy/d, yy/dd, yyyy/dd
-l lang\t\t Language to use. Default: rb
EOF

declare -A HEADERS
HEADERS[rb]=$(cat <<'HEADER'
#!/usr/bin/env ruby
# frozen_string_literal: true

HEADER
)
HEADERS[js]=$(cat <<'HEADER'
#!/usr/bin/env node

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

# Ref: https://www.cicoria.com/loading-env-dotenv-using-bash-or-zsh/
load_dotenv() {
	set -o allexport; source .env; set +o allexport
}

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
	curl --remote-name --remote-header-name --silent --fail --cookie "session=$AOC_SESSION" "$url"
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
#fetch_input $year $(echo $day | bc)


if [ -n "${TMUX+x}" ]; then
	tmux split-window -h
	tmux last-pane
fi

# vim alias not set to nvim, assume $EDITOR is a proper editor (=vi-like).
$EDITOR -c "tabedit part1.${arg_lang} | sp input | tabedit input1.0 | sp output1.0 | tabedit part2.${arg_lang} | normal 2gt " README.txt


cd_git_root
bin/stats.sh

printf '\ngit add %s && git commit -m "Add %s" && git push && tig\n' "$path" "$path"
