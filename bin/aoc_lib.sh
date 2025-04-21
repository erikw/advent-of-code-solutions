# Initialize a main script for AoC.
aoc_init_script() {
	aoc_cd_git_root
	aoc_load_dotenv
}

# cd into the git root dir.
aoc_cd_git_root() {
	cd "$(git rev-parse --show-toplevel)"
}

# Load .env if it exist.
# Ref: https://www.cicoria.com/loading-env-dotenv-using-bash-or-zsh/
aoc_load_dotenv() {
	test -f .env || return
	set -o allexport; source .env; set +o allexport
}


# Fetch year from $*, or default to this year's year.
aoc_parse_year() {
	local year=$(date +%Y)
	if [ $# -eq 1 ]; then
		local ym=(${1//\// })  # Format: yyyy/dd
		year=${ym[0]}

		test ${#year} -eq 4 || year="20$year"
	fi
	echo "$year"
}

# Fetch day from $*, or default to today's day.
aoc_parse_day() {
	local day=$(date +%d)
	if [ $# -eq 1 ]; then
		local ym=(${1//\// })  # Format: yyyy/dd
		day=${ym[1]}
		test ${#day} -eq 2 || day="0$day"
	fi
	echo "$day"
}

# Fetch input, unless present (to prevent DOS).
aoc_fetch_input() {
	local year=$1
	local day=$(echo $2 | bc) # Strip leading 0

	local url_fmt="https://adventofcode.com/%d/day/%d/input"
	local url="$(printf "$url_fmt" $year $day)"

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
	local year=$1
	local day0=$2
	local day=$(echo $day0 | bc)

	# TODO prevent creating README if already existing? wait until I've backfilled.

	local url_base="adventofcode.com/${year}/day/${day}"
	local url="https://${url_base}"

	read -rd '' content <<-MD || :
	# Advent of Code - ${year} Day ${day}
	Here are my solutions to this puzzle.

	* Problem description: [${url_base}](${url})
	* Input: [${url_base}/input](${url}/input)

	Fetch input by setting \`\$AOC_SESSION\` and then:
	\`\`\`bash
	curl -OJLsb session=\$AOC_SESSION ${url_base}/input
	\`\`\`
	MD

	echo "$content" > README.md

}

# Create year/day directory and cd into it.
aoc_create_enter() {
	local year="$1"
	local day="$2"

	local path="$year/$day"
	mkdir -p $path
	cd "$path"
}