#!/usr/]/env python3
import fileinput
import itertools
from collections import defaultdict

CHAMBER_WIDTH = 7
TOTAL_ROCKS = 1
# TOTAL_ROCKS = 5
# TOTAL_ROCKS = 2022

ROCK_PAD_LEFT = 2
ROCK_PAD_BOTTOM = 3

JET_LEFT = "<"
JET_RIGHT = ">"

SYM_SPACE = "."
SYM_ROCK_FALL = "@"
SYM_ROCK_REST = "#"

# ROCKS = [
#     [[".", ".", "@", "@", "@", "@", "."]],
#     [
#         [".", ".", ".", "@", ".", ".", "."],
#         [".", ".", "@", "@", "@", ".", "."],
#         [".", ".", ".", "@", ".", ".", "."],
#     ],
#     [
#         [".", ".", ".", ".", "@", ".", "."],
#         [".", ".", ".", ".", "@", ".", "."],
#         [".", ".", "@", "@", "@", ".", "."],
#     ],
#     [
#         [".", ".", "@", ".", ".", ".", "."],
#         [".", ".", "@", ".", ".", ".", "."],
#         [".", ".", "@", ".", ".", ".", "."],
#         [".", ".", "@", ".", ".", ".", "."],
#     ],
#     [
#     [".", ".", "@", "@", ".", ".", "."],
#     [".", ".", "@", "@", ".", ".", "."]],
# ]
ROCKS = [
    set([2j, 3j, 4j, 5j]),
    set([3j, 1 + 2j, 1 + 3j, 1 + 4j, 2 + 3j]),
    set([2j, 3j, 4j, 1 + 4j, 2 + 4j]),
    set([2j, 1 + 2j, 2 + 2j, 3 + 2j]),
    set([2j, 3j, 1 + 2j, 1 + 3j]),
]


# PADDING = [[SYM_SPACE] * CHAMBER_WIDTH] * ROCK_PAD_BOTTOM


def read_jet_pattern():
    return itertools.cycle(next(fileinput.input()).rstrip("\n"))


def print_chamber(chamber):
    for row in reversed(chamber):
        print("|{:s}|".format("".join(row)))
    print("+" + "-" * CHAMBER_WIDTH + "+")
    print()


def main():
    jet_pattern = read_jet_pattern()
    # chamber = [[SYM_SPACE] * CHAMBER_WIDTH]
    chamber = defaultdict(lambda: SYM_SPACE)
    top = 0

    for rock_n in range(TOTAL_ROCKS):
        print(f"Rock number {rock_n:d} rock begins falling:")

        # chamber.extend(PADDING)
        # print_chamber(chamber)

        rock = ROCKS[rock_n % len(ROCKS)]
        # rock_height = len(rock)
        # chamber.extend(rock)
        # print_chamber(chamber)
        rock_d = complex(ROCK_PAD_LEFT, top + ROCK_PAD_BOTTOM + 1)
        rock = [c + rock_d for c in rock]  # TODO verify it works

        # while True:
        #     jet = next(jet_pattern)
        #     print(f"Jet of gas pushes rock {"left" if jet == JET_LEFT else "right"}:")


if __name__ == "__main__":
    main()
