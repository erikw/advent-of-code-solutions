#!/usr/bin/env python3
import fileinput
from collections import defaultdict

# 1600571428586 correct according to o4
# 1600571428577 too high
# 1600571428576 too high
# 1600571428568 not right
# 1600000000007 not right
# 1595988538691 correct according to o3, o5, and is so

DEBUG = False

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
    seen = {}  # state -> (rock_n (when state was last seen), top at that time)
    rock_n = 0
    skipped = False  # TODO should be able to not do this?
    top_skip = 0

    while rock_n < TOTAL_ROCKS:
        rock_i = rock_n % len(ROCKS)
        rock = ROCKS[rock_i]
        rock_d = complex(top + ROCK_PAD_BOTTOM + 1, ROCK_PAD_LEFT)
        rock = [c + rock_d for c in rock]

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

        dprint(type(state))
        dprint(f"rock_n={rock_n}, top = {top}")
        if DEBUG:
            __import__("pprint").pprint(state)
        print_chamber(chamber)
        if state in seen and not skipped and seen[state][2] == 2:
            skipped = True
            cycle_len = rock_n - seen[state][0]
            top_past = seen[state][1]
            left = TOTAL_ROCKS - rock_n
            cycles_skip = left // cycle_len

            print(
                f"Found a cycle at rock {rock_n} at top {top}. State last seen at rock {seen[state][0]} with top {top_past}. Cycle len of {cycle_len}. Will skip ahead {cycles_skip} cycles, meaning adding {(top - top_past) * cycles_skip} to top. New rock_n={rock_n + cycle_len * cycles_skip}"
            )

            rock_n += cycle_len * cycles_skip
            top_skip = (top - top_past) * cycles_skip

        elif state in seen and not skipped:
            seen[state] = (rock_n, top, 2)
        else:
            seen[state] = (rock_n, top, 1)

        # steps = 0
        while True:
            # steps += 1
            # Jet push
            jet = jet_pattern[jet_i]
            jet_i = (jet_i + 1) % len(jet_pattern)

            rock_inserted = set()
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
                rock_inserted.add(cn)
            if not abort_move:
                rock = rock_inserted

            # Fall down
            rock_inserted = set()
            delta = DELTA_DOWN
            abort_move = False
            for c in rock:
                cn = c + delta
                if cn in chamber and chamber[cn] == SYM_ROCK_REST or cn.real < 0:
                    abort_move = True
                rock_inserted.add(cn)
            if abort_move:
                for c in rock:
                    chamber[c] = SYM_ROCK_REST
                top = int(max([c.real for c in chamber.keys()]))
                break
            else:
                rock = rock_inserted
        rock_n += 1

    return top + 1 + top_skip


def main():
    jet_pattern = read_jet_pattern()
    height = find_tower_height(jet_pattern)
    print(height)


if __name__ == "__main__":
    main()
