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