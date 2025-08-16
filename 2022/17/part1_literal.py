#!/usr/bin/env python3
import fileinput
import itertools
from pprint import pprint

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

ROCKS = [
    [
        ['.', '.', '@', '@', '@', '@', '.']
    ],

    [
        ['.', '.', '@', '.', '.', '.', '.'],
        ['.', '@', '@', '@', '.', '.', '.'],
        ['.', '.', '@', '.', '.', '.', '.'],
    ],
    [
        ['.', '.', '.', '.', '@', '.', '.'],
        ['.', '.', '.', '.', '@', '.', '.'],
        ['.', '.', '@', '@', '@', '.', '.'],
    ],
    [
        ['.', '.', '@', '.', '.', '.', '.'],
        ['.', '.', '@', '.', '.', '.', '.'],
        ['.', '.', '@', '.', '.', '.', '.'],
        ['.', '.', '@', '.', '.', '.', '.']
    ],
    [
        ['.', '.', '@', '@', '.', '.', '.'],
        ['.', '.', '@', '@', '.', '.', '.']
    ],
]


PADDING = [
    [SYM_SPACE] * CHAMBER_WIDTH
] * ROCK_PAD_BOTTOM

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
    chamber = []
    top = 0

    for rock_n in range(TOTAL_ROCKS):
        print(f"Rock number {rock_n:d} rock begins falling:")


        chamber.extend(PADDING)
        # print_chamber(chamber)

        rock = list(reversed(ROCKS[rock_n % len(ROCKS)]))
        rock_height = len(rock)
        chamber.extend(rock)
        print_chamber(chamber)

        while True:
            jet = next(jet_pattern)
            print(f"Jet of gas pushes rock {"left" if jet == JET_LEFT else "right"}:")






if __name__ == "__main__":
    main()
