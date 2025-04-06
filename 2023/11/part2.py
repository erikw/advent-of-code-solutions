#!/usr/bin/env python3
import fileinput
from collections import defaultdict
from itertools import combinations

PIXEL_SPACE = "."
PIXEL_GALAXY = "#"

# SPACE_EXPANSION = 10 - 1
# SPACE_EXPANSION = 100 - 1
SPACE_EXPANSION = 1000000 - 1


def read_image():
    galaxies = []
    rows = list(fileinput.input())
    for row, line in enumerate(rows):
        for col, pixel in enumerate(line[:-1]):
            if pixel == PIXEL_GALAXY:
                galaxies.append((row, col))
    return (len(rows), len(rows[0]), galaxies)


def expand_rows(univ_rows, galaxies):
    galaxies_by_row = defaultdict(list)
    for row, col in galaxies:
        galaxies_by_row[row].append(col)

    galaxies_expanded = []
    row = 0
    rows_expanded = 0
    while row < univ_rows:
        if row in galaxies_by_row:
            for col in galaxies_by_row[row]:
                galaxies_expanded.append((row + rows_expanded * SPACE_EXPANSION, col))
        else:
            rows_expanded += 1
        row += 1

    return galaxies_expanded


def expand_universe(univ_rows, univ_cols, galaxies):
    exp_row = expand_rows(univ_rows, galaxies)
    exp_row_inv = sorted([(col, row) for row, col in exp_row])
    exp_row_col_inv = expand_rows(univ_cols, exp_row_inv)
    return sorted([(row, col) for col, row in exp_row_col_inv])


def shortest_distance(galaxy1, galaxy2):
    # Manhattan distance
    return abs(galaxy2[0] - galaxy1[0]) + abs(galaxy2[1] - galaxy1[1])


def main():
    univ_rows, univ_cols, galaxies = read_image()
    galaxies_expanded = expand_universe(univ_rows, univ_cols, galaxies)

    len_sum = 0
    for g1, g2 in combinations(galaxies_expanded, 2):
        len_sum += shortest_distance(g1, g2)
    print(len_sum)


if __name__ == "__main__":
    main()
