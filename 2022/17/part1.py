#!/usr/bin/env python3
import fileinput
import itertools

DEBUG = False

# TOTAL_ROCKS = 5
TOTAL_ROCKS = 2022

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
    return itertools.cycle(next(fileinput.input()).rstrip("\n"))


def print_chamber(chamber, rock=[]):
    if not DEBUG:
        return

    chamber = chamber.copy()
    for c in rock:
        chamber.add(c)

    max_x = int(max(c.real for c in chamber)) if chamber else 0
    for x in range(max_x, -1, -1):
        dprint("|", end="")
        for y in range(CHAMBER_WIDTH):
            dprint(chamber[complex(x, y)], end="")
        dprint("|")
    dprint("+" + "-" * CHAMBER_WIDTH + "+\n")


def find_tower_height(jet_pattern):
    chamber = set()  # Coordinates [complex] for rock parts at rest.
    top = -1

    for rock_n in range(TOTAL_ROCKS):
        if rock_n == 0:
            dprint("The first rock begins falling:")
        else:
            dprint("A new rock begins falling:")

        rock = ROCKS[rock_n % len(ROCKS)]
        rock_d = complex(top + ROCK_PAD_BOTTOM + 1, ROCK_PAD_LEFT)
        rock = [c + rock_d for c in rock]

        print_chamber(chamber, rock)

        while True:
            # Jet push
            jet = next(jet_pattern)
            rock_inserted = set()
            delta = DELTA_LEFT if jet == JET_LEFT else DELTA_RIGHT
            abort_move = False
            for c in rock:
                cn = c + delta
                if (
                    not (0 <= cn.imag < CHAMBER_WIDTH)
                    or cn in chamber
                    and cn in chamber
                ):
                    abort_move = True
                rock_inserted.add(cn)
            dir = "left" if jet == JET_LEFT else "right"
            if abort_move:
                dprint(f"Jet of gas pushes rock {dir}, but nothing happens:")
            else:
                dprint(f"Jet of gas pushes rock {dir}:")
                rock = rock_inserted
            print_chamber(chamber, rock)

            # Fall down
            rock_inserted = set()
            delta = DELTA_DOWN
            abort_move = False
            for c in rock:
                cn = c + delta
                if cn in chamber or cn.real < 0:
                    abort_move = True
                rock_inserted.add(cn)
            if abort_move:
                dprint("Rock falls 1 unit, causing it to come to rest:")
                for c in rock:
                    chamber.add(c)
                top = max([c.real for c in chamber])
                print_chamber(chamber)
                break
            else:
                dprint("Rock falls 1 unit:")
                rock = rock_inserted
                print_chamber(chamber, rock)

    return int(top + 1)


def main():
    jet_pattern = read_jet_pattern()
    height = find_tower_height(jet_pattern)
    print(height)


if __name__ == "__main__":
    main()
