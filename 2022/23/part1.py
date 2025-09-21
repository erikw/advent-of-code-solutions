#!/usr/bin/env python3
import fileinput
from collections import defaultdict
from functools import reduce

ROUNDS = 10

SYM_ELV = "#"
SYM_GROUND = "."


DIR_N = -1 + 0j
DIR_S = 1 + 0j
DIR_W = 0 + -1j
DIR_E = 0 + 1j
DIR_NW = -1 + -1j
DIR_NE = -1 + 1j
DIR_SW = 1 + -1j
DIR_SE = 1 + 1j

DIRS = [
    DIR_N,
    DIR_S,
    DIR_W,
    DIR_E,
    DIR_NW,
    DIR_NE,
    DIR_SW,
    DIR_SE,
]

DIRS_ORDERS = [
    [DIR_N, DIR_NE, DIR_NW],
    [DIR_S, DIR_SE, DIR_SW],
    [DIR_W, DIR_NW, DIR_SW],
    [DIR_E, DIR_NE, DIR_SE],
]


def read_input():
    grove = set()
    for row, line in enumerate(fileinput.input()):
        for col, sym in enumerate(line.rstrip("\n")):
            if sym == SYM_ELV:
                grove.add(complex(row, col))
    return grove


def minmax(items):
    return reduce(
        lambda acc, x: (min(acc[0], x), max(acc[1], x)), items, (items[0], items[0])
    )


def print_grove(grove, label):
    print(f"== {label} ==")

    row_min, row_max = minmax([int(p.real) for p in grove])
    col_min, col_max = minmax([int(p.imag) for p in grove])
    for row in range(row_min, row_max + 1):
        for col in range(col_min, col_max + 1):
            pos = complex(row, col)
            print(SYM_ELV if pos in grove else SYM_GROUND, end="")
        print()
    print()


def main():
    grove = read_input()
    # print_grove(grove, "Initial State")
    dir_start = 0

    for round in range(ROUNDS):
        # First half; considerations
        proposals = defaultdict(list)  # pos_prop -> [pos_elf]
        for pos_elf in grove:
            if not any((pos_elf + d) in grove for d in DIRS):
                continue

            for dir_idx in range(len(DIRS_ORDERS)):
                dir_deltas = DIRS_ORDERS[(dir_start + dir_idx) % len(DIRS_ORDERS)]
                if not any((pos_elf + d) in grove for d in dir_deltas):
                    pos_prop = pos_elf + dir_deltas[0]
                    proposals[pos_prop].append(pos_elf)
                    break

        # Second half; simultaneous moving
        for pos_prop, pos_elves in proposals.items():
            if len(pos_elves) == 1:
                grove.remove(pos_elves[0])
                grove.add(pos_prop)

        # Finally; direction rotation
        dir_start = (dir_start + 1) % len(DIRS_ORDERS)

        # print_grove(grove, f"End of Round {round + 1}")

    row_min, row_max = minmax([int(p.real) for p in grove])
    col_min, col_max = minmax([int(p.imag) for p in grove])
    row_len = row_max - row_min + 1
    col_len = col_max - col_min + 1
    empty_tiles = row_len * col_len - len(grove)
    print(empty_tiles)


if __name__ == "__main__":
    main()
