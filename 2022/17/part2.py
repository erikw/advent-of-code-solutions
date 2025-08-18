#!/usr/bin/env python3
import fileinput

DEBUG = False

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


def read_jet_pattern():
    return next(fileinput.input()).rstrip("\n")


def find_tower_height(jet_pattern):
    chamber = set()  # Coordinates [complex] for rock parts at rest.
    top = -1
    jet_i = 0
    seen = (
        {}
    )  # state -> (rock_n (when state last seen), top at state, number times seen)
    rock_n = 0
    skipped = False  # If we have already skipped forward, do only once.
    top_fastforwards = 0

    while rock_n < TOTAL_ROCKS:
        rock_i = rock_n % len(ROCKS)
        rock = ROCKS[rock_i]
        rock_d = complex(top + ROCK_PAD_BOTTOM + 1, ROCK_PAD_LEFT)
        rock = [c + rock_d for c in rock]

        # Calculate a state key to detect if we've seen this state before.
        # state = (current rock type, jet stream position, shape of top of each column*)
        # * saved as relative difference between the current tower height and the tallest rock piece in that column.
        chamber_tops = []
        for y in range(CHAMBER_WIDTH):
            x_top = max([c.real for c in chamber if c.imag == y] + [-1])
            chamber_tops.append(int(top - x_top))
        state = (rock_i, jet_i, tuple(chamber_tops))

        # Make sure we see the repeated state 2 times, as the first time the system might not have stabilzied itself yet.
        if state in seen and not skipped and seen[state][2] == 2:
            skipped = True
            cycle_len = rock_n - seen[state][0]
            top_past = seen[state][1]
            left = TOTAL_ROCKS - rock_n
            cycles_skip = left // cycle_len

            rock_n += cycle_len * cycles_skip
            # Saving top steps to skip for later. Let the while-loop runing the remaing rocks until TOTAL_ROCKS, then add at the end.
            top_fastforwards = (top - top_past) * cycles_skip

        elif state in seen:
            seen[state] = (rock_n, top, seen[state][2] + 1)
        else:
            seen[state] = (rock_n, top, 1)

        while True:
            # Jet push
            jet = jet_pattern[jet_i]
            jet_i = (jet_i + 1) % len(jet_pattern)

            rock_inserted = set()
            delta = DELTA_LEFT if jet == JET_LEFT else DELTA_RIGHT
            abort_move = False
            for c in rock:
                cn = c + delta
                if not (0 <= cn.imag < CHAMBER_WIDTH) or cn in chamber:
                    abort_move = True
                rock_inserted.add(cn)
            if not abort_move:
                rock = rock_inserted

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
                for c in rock:
                    chamber.add(c)
                top = int(max([c.real for c in chamber]))
                break
            else:
                rock = rock_inserted
        rock_n += 1

    return top + 1 + top_fastforwards


def main():
    jet_pattern = read_jet_pattern()
    height = find_tower_height(jet_pattern)
    print(height)


if __name__ == "__main__":
    main()
