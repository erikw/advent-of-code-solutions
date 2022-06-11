#!/usr/bin/env bash
# Usage:
# $ solve_day.sh
# $ solve_day.sh yy/d
# $ solve_day.sh yyyy/dd
# TODO consider using https://github.com/GreenLightning/advent-of-code-downloader next year instead.
#      Or even better https://pypi.org/project/advent-of-code-data/

set -eu

FILES=(README.txt part1.rb input input1.0 output1.0 part2.rb)

enter_day() {
	local year=$1
	local day=$2
	local files_arrayname=$3[@]
	local files=("${!files_arrayname}")

	path="$year/$day"
	mkdir -p $path
	cd "$path"

	touch ${files[@]}
	chmod u+x *.rb
	for r in *.rb; do
		printf "#!/usr/bin/env ruby\n\n" > $r
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

year=$(date +%Y)
day=$(date +%d)
if [ $# -eq 1 ]; then
	ym=(${1//\// })  # Format: yyyy/dd
	year=${ym[0]}
	day=${ym[1]}

	test ${#year} -eq 4 || year="20$year"
	test ${#day}  -eq 2 || day="0$day"
fi


load_dotenv
enter_day $year $day FILES
fetch_input $year $(echo $day | bc)


if [ -n "${TMUX+x}" ]; then
	tmux split-window -h
	tmux last-pane
fi

#nvim -p ${FILES[@]}
# vim alias not set to nvim, assume $EDITOR is a proper editor (=vi-like).
$EDITOR -c "tabedit part1.rb | sp input | tabedit input1.0 | sp output1.0 | tabedit part2.rb | normal 2gt " README.txt


cd -
./solved_puzzles.sh

printf '\ngit add %s && git commit -m "Add %s" && git push && tig\n' "$path" "$path"
