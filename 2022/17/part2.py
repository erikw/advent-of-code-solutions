#!/usr/bin/env python3
import fileinput
import itertools
from collections import defaultdict

DEBUG = True

# TOTAL_ROCKS = 2022
TOTAL_ROCKS = 1000000000000

CHAMBER_WIDTH = 7
ROCK_PAD_LEFT = 2
ROCK_PAD_BOTTOM = 3

JET_LEFT = "<"
JET_RIGHT = ">"

DELTA_LEFT = -1j
DELTA_RIGHT = 1j
DELTA_DOWN = -1 + 0j

SYM_SPACE = "."
SYM_ROCK_FALL = "@"
SYM_ROCK_REST = "#"

ROCKS = [
    set([0j, 1j, 2j, 3j]),
    set([1j, 1 + 0j, 1 + 1j, 1 + 2j, 2 + 1j]),
    set([0j, 1j, 2j, 1 + 2j, 2 + 2j]),
    set([0j, 1 + 0j, 2 + 0j, 3 + 0j]),
    set([0j, 1j, 1 + 0j, 1 + 1j]),
]


def dprint(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)


def read_jet_pattern():
    return next(fileinput.input()).rstrip("\n")


def print_chamber(chamber, rock=[]):
    if not DEBUG:
        return

    chamber = chamber.copy()
    for c in rock:
        chamber[c] = SYM_ROCK_FALL

    max_x = int(max(c.real for c in chamber.keys())) if chamber else 0
    for x in range(max_x, -1, -1):
        dprint("|", end="")
        for y in range(CHAMBER_WIDTH):
            dprint(chamber[complex(x, y)], end="")
        dprint("|")
    dprint("+" + "-" * CHAMBER_WIDTH + "+\n")


def find_tower_height(jet_pattern):
    chamber = defaultdict(
        lambda: SYM_SPACE
    )  # TODO could be a set just, no need for the value.
    top = -1
    jet_i = 0

    for rock_n in range(TOTAL_ROCKS):
        rock_i = rock_n % len(ROCKS)
        rock = ROCKS[rock_i]
        rock_d = complex(top + ROCK_PAD_BOTTOM + 1, ROCK_PAD_LEFT)
        rock = [c + rock_d for c in rock]

        seen = {}  # state -> rock_n (when state was last seen)
        # key = (rock_i, jet_i % jet_l, [for each col, the top resting rock X val's difference to current top X val])
        chamber_tops = []
        for y in range(CHAMBER_WIDTH):
            x_top_d = max(
                [c for c in chamber.keys() if c.imag == y] + [0], key=lambda c: c.real
            )
            x_top = max([c.real for c in chamber.keys() if c.imag == y] + [-1])
            dprint(f"For y={y} the x_top={x_top}. x_top_d={x_top_d}")
            chamber_tops.append(int(top - x_top))
        state = (rock_i, jet_i, tuple(chamber_tops))

        dprint(state)
        dprint(f"top = {top}")
        print_chamber(chamber)
        if state in seen:
            print(
                f"Found a cycle at rock {rock_n}. State last seen at rock {seen[state]}. Cycle len of {rock_n - seen[state]}"
            )
        else:
            seen[state] = rock_n

        # steps = 0
        while True:
            # steps += 1
            # Jet push
            jet = jet_pattern[jet_i]
            jet_i = (jet_i + 1) % len(jet_pattern)

            rock_n = set()
            delta = DELTA_LEFT if jet == JET_LEFT else DELTA_RIGHT
            abort_move = False
            for c in rock:
                cn = c + delta
                if (
                    not (0 <= cn.imag < CHAMBER_WIDTH)
                    or cn in chamber
                    and chamber[cn] == SYM_ROCK_REST
                ):
                    abort_move = True
                rock_n.add(cn)
            if not abort_move:
                rock = rock_n

            # Fall down
            rock_n = set()
            delta = DELTA_DOWN
            abort_move = False
            for c in rock:
                cn = c + delta
                if cn in chamber and chamber[cn] == SYM_ROCK_REST or cn.real < 0:
                    abort_move = True
                rock_n.add(cn)
            if abort_move:
                for c in rock:
                    chamber[c] = SYM_ROCK_REST
                top = max([c.real for c in chamber.keys()])
                break
            else:
                rock = rock_n

    return int(top + 1)


def main():
    jet_pattern = read_jet_pattern()
    height = find_tower_height(jet_pattern)
    print(height)


if __name__ == "__main__":
    main()
