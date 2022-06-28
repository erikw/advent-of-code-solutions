#!/usr/bin/env bash
# Assumption: a README.txt means a solved puzzle.

nbr_solved() {
	local path="$1"
	test -z ${path} && path=.

	# Ref: https://stackoverflow.com/a/69326159/265508
	find "$path" -name README.txt -exec printf %c {} + | wc -c | tr -d ' '
}

printf "Number of solved puzzles:\n"
years=$(find . -type d -regex "\./*[0-9]*" -maxdepth 1 | grep -oE "\d+" | sort)
for year in $years; do
	solved=$(nbr_solved $year)
	test $solved = "25" && solved="25 ⭐️"
	printf "%s: %s\n" $year "$solved"
done
printf "===========\n"
printf "Total: %d\n" $(nbr_solved)
