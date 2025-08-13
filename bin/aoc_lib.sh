#!/usr/bin/env bash
# Shared helpers for AoC scripts.


# Remove leading zeroes from a number
# The 10# prefix tells bash to treat the number as base-10, which automatically removes leading zeroes.
__aoc_strip_leading_zeroes() {
	local num="$1"
	echo $((10#$num))
}

# Initialize a main script for AoC.
aoc_init_script() {
	aoc_cd_git_root
	aoc_load_dotenv
}

# cd into the git root dir.
aoc_cd_git_root() {
	cd "$(git rev-parse --show-toplevel)" || exit 7
}

# Load .env if it exist.
# Ref: https://www.cicoria.com/loading-env-dotenv-using-bash-or-zsh/
aoc_load_dotenv() {
	test -f .env || return
	set -o allexport
	# shellcheck source=/dev/null
	source .env
	set +o allexport
}


# Fetch year from $*, or default to this year's year.
aoc_parse_year() {
	local date="${1:-}" # Format: yyyy/dd
	local year ym
	year=$(date +%Y)
	if [ $# -eq 1 ]; then
		IFS="/" read -ra ym <<< "$date"
		if (( ${#ym[@]} != 2 )); then
			echo "Could not parse year." >&2
			exit 7
		fi

		year=${ym[0]}
		test ${#year} -eq 4 || year="20$year"
	elif [ "$(date +%m)" != 12 ]; then
		echo "A bit too eager? It's not december yet." >&2
		exit 12
	fi
	echo "$year"
}

# Fetch day from $*, or default to today's day.
aoc_parse_day() {
	local date="${1:-}" # Format: yyyy/dd
	local day ym
	day=$(date +%d)
	if [ $# -eq 1 ]; then
		IFS="/" read -ra ym <<< "$date"
		if (( ${#ym[@]} != 2 )); then
			echo "Could not parse date." >&2
			exit 9
		fi
		day=${ym[1]}
		test ${#day} -eq 2 || day="0$day"
	elif [ "$(date +%m)" != 12 ]; then
		echo "A bit too eager? It's not december yet." >&2
		exit 12
	fi
	echo "$day"
}

# Fetch input, unless present (to prevent DOS).
aoc_fetch_input() {
	local year day0 day url_fmt url
	year="$1"
	day0="$2"
	day=$(__aoc_strip_leading_zeroes "$day0")

	url_fmt="https://adventofcode.com/%d/day/%d/input"
	# shellcheck disable=SC2059
	url="$(printf "$url_fmt" "$year" "$day")"

	test -e input && return

	if [ -z "${AOC_SESSION+x}" ]; then
		printf "\$AOC_SESSION is not set. Fetch the 'session' cookie value from your browser and put it in to .env:\n" >&2
		printf '$ echo AOC_SESSION=value > .env\n' >&2
		exit 2
	fi
	# Include contact method in user agent as requested by @topaz: https://www.reddit.com/r/adventofcode/comments/z9dhtd/please_include_your_contact_info_in_the_useragent/
	curl --remote-name --remote-header-name --silent --fail -A 'https://erikw.me/contact' --cookie "session=$AOC_SESSION" "$url"
}

# Create README.md for current day.
aoc_create_readme() {
	local year day0 day url_base url
	year="$1"
	day0="$2"
	day=$(__aoc_strip_leading_zeroes "$day0")

	url_base="adventofcode.com/${year}/day/${day}"
	url="https://${url_base}"

	# NOTE remember to run backfill_days.sh after changing the template below.
	read -rd '' content <<-MD || :
	# Advent of Code - ${year} Day ${day}
	Here are my solutions to this puzzle.

	* Problem instructions: [${url_base}](${url})
	* Input: [${url_base}/input](${url}/input)

	Fetch input by exporting \`\$AOC_SESSION\` in your shell and then:
	\`\`\`bash
	curl -OJLsb session=\$AOC_SESSION ${url_base}/input
	\`\`\`

	or run \`fetch_input.sh\` in this directory.
	MD

	echo "$content" > README.md
}


# Create instructions.url for current day.
aoc_create_instructions_url() {
	local year day0 day url
	year="$1"
	day0="$2"
	day=$(__aoc_strip_leading_zeroes "$day0")

	url="https://adventofcode.com/${year}/day/${day}"

	# NOTE remember to run backfill_days.sh after changing the template below.
	read -rd '' content <<-URL_FILE || :
	[InternetShortcut]
	URL = ${url}
	URL_FILE

	echo "$content" > instructions.url
}


# Create fetch_input.sh for current day.
aoc_create_input_script() {
	local year day0 day url
	year="$1"
	day0="$2"
	day=$(__aoc_strip_leading_zeroes "$day0")

	url="https://adventofcode.com/${year}/day/${day}/input"

	# NOTE remember to run backfill_days.sh after changing the template below.
	read -rd '' content <<-SCRIPT || :
	#!/usr/bin/env sh
	# Make sure \$AOC_SESSION is exported before running this script.

	curl --remote-name --remote-header-name --silent --fail -A 'https://erikw.me/contact' --cookie "session=\$AOC_SESSION" "$url"
	test "\$?" -eq 0 && echo "Fetched input" && exit 0 || echo "Failed to fetch input" && exit 1
	SCRIPT

	echo "$content" > fetch_input.sh
	chmod 744 fetch_input.sh
}


# Create boilerplate files for a year/day.
# NOTE only generate files that should be checked in here. Especially not
# aoc_fetch_input as the backfill script should not spam curl(1)s.
aoc_create_boilerplates() {
	local year="$1"
	local day="$2"

	aoc_create_readme "$year" "$day"
	aoc_create_instructions_url "$year" "$day"
	aoc_create_input_script "$year" "$day"
}


# Create year/day directory and cd into it.
aoc_create_enter() {
	local year="$1"
	local day="$2"

	local path="$year/$day"
	mkdir -p "$path"
	cd "$path" || exit 6
}
