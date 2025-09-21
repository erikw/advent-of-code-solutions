#!/usr/bin/env python3
import fileinput
from collections import defaultdict
from functools import reduce

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


def main():
    grove = read_input()
    dir_start = 0
    rounds = 0

    while True:
        rounds += 1
        # First half; considerations
        proposals = defaultdict(list)  # pos_prop -> [pos_elf]
        moved = False
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
                moved = True
                grove.remove(pos_elves[0])
                grove.add(pos_prop)

        # Finally; direction rotation
        dir_start = (dir_start + 1) % len(DIRS_ORDERS)

        if not moved:
            break

    print(rounds)


if __name__ == "__main__":
    main()
