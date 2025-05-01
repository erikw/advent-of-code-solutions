#!/usr/bin/env python3
import fileinput
from pprint import pprint

SYM_TRENCH = "#"
SYM_TERRAIN = "."

DIR_DELTA = {
    "R": 1j,
    "L": -1j,
    "U": -1,
    "D": 1,
}


def find_trench_loop():
    pos = (
        0  # Let's call the starting point origin, and make it at (0,0) for simplicity.
    )
    trench_loop: complex = {pos}
    row_min, col_min = 0, 0
    row_max, col_max = 0, 0
    for line in fileinput.input():
        dir, meters, rgb = line.rstrip("\n").split()
        meters = int(meters)
        rgb = rgb.strip("(#)")

        delta = DIR_DELTA[dir]
        for _ in range(meters):
            pos += delta
            trench_loop.add(pos)
            row_min, row_max = min(row_min, pos.real), max(row_max, pos.real)
            col_min, col_max = min(col_min, pos.imag), max(col_max, pos.imag)
    return (
        trench_loop,
        (int(row_min), int(row_max) + 1),
        (int(col_min), int(col_max) + 1),
    )


def raytrace_count(trench_loop, col_dim, pos):
    count = 0
    in_lagoon = False
    found_trench_up = False
    found_trench_down = False

    # Save quite some CPU time by shooting ray in closest direction left or right.
    if pos.imag < col_dim[0] + (col_dim[1] - col_dim[0]) / 2:
        steps = range(int(pos.imag), col_dim[0] - 1, -1)
        dir = DIR_DELTA["L"]
    else:
        steps = range(int(pos.imag), col_dim[1])
        dir = DIR_DELTA["R"]

    for _ in steps:
        pos += dir

        # It counts as crossing the shape (lagoon loop) only if the shape goes up and down from this line, otherwise it's not really crossing the edge like a "^" shape.
        pos_up = pos + DIR_DELTA["U"]
        pos_down = pos + DIR_DELTA["D"]
        if pos_up in trench_loop:
            found_trench_up = True
        if pos_down in trench_loop:
            found_trench_down = True

        if pos in trench_loop:
            in_lagoon = True
        elif in_lagoon:
            in_lagoon = False
            if found_trench_up and found_trench_down:
                count += 1
                found_trench_up = False
                found_trench_down = False
    return count


def dig_out_interior(trench_loop, row_dim, col_dim):
    lagoon_map = trench_loop.copy()
    for row in range(*row_dim):
        for col in range(*col_dim):
            pos = complex(row, col)
            if (
                pos not in trench_loop
                and raytrace_count(trench_loop, col_dim, pos) % 2 == 1
            ):
                lagoon_map.add(pos)
    return lagoon_map


def print_map(dig_map, row_dim, col_dim):
    for row in range(*row_dim):
        for col in range(*col_dim):
            pos = complex(row, col)
            print(SYM_TRENCH if pos in dig_map else SYM_TERRAIN, end="")
        print()


def main():
    trench_loop, row_dim, col_dim = find_trench_loop()
    # print_map(trench_loop, row_dim, col_dim)

    lagoon_map = dig_out_interior(trench_loop, row_dim, col_dim)
    # print("\n\n==== After dig out")
    # print_map(lagoon_map, row_dim, col_dim)

    print(len(lagoon_map))


if __name__ == "__main__":
    main()
