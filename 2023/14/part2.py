#!/usr/bin/env python3
import fileinput

SYM_ROCK_ROUND = "O"
SYM_ROCK_CUBE = "#"
SYM_EMPTY = "."

TOTAL_CYCLES = 1000000000


def read_platform():
    return [list(l.rstrip("\n")) for l in fileinput.input()]


def print_platform(platform, op="tilting"):
    print(f"\n=== Platform after {op}")
    for row in platform:
        print("".join(row))


def calc_north_load(platform):
    load = 0
    for row in range(len(platform)):
        for col in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                load += len(platform) - row
    return load


def roll(platform, row, col, row_step, col_step):
    while (
        0 <= row + row_step < len(platform)
        and 0 <= col + col_step < len(platform[0])
        and platform[row + row_step][col + col_step] == SYM_EMPTY
    ):
        platform[row + row_step][col + col_step] = SYM_ROCK_ROUND
        platform[row][col] = SYM_EMPTY
        row += row_step
        col += col_step


def tilt_north(platform):
    for row in range(len(platform)):
        for col in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                roll(platform, row, col, -1, 0)


def tilt_west(platform):
    for col in range(len(platform)):
        for row in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                roll(platform, row, col, 0, -1)


def tilt_south(platform):
    for row in range(len(platform) - 1, -1, -1):
        for col in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                roll(platform, row, col, 1, 0)


def tilt_east(platform):
    for col in range(len(platform) - 1, -1, -1):
        for row in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                roll(platform, row, col, 0, 1)


def tilt_cycle(platform):
    tilt_north(platform)
    tilt_west(platform)
    tilt_south(platform)
    tilt_east(platform)


def hash_platform(platform):
    return hash("".join("".join(r) for r in platform))


def main():
    platform = read_platform()

    hashes = {}  # hash -> cycle
    hash_cycle = hash_platform(platform)
    cycle = 0
    while hash_cycle not in hashes:
        hashes[hash_cycle] = cycle
        tilt_cycle(platform)
        hash_cycle = hash_platform(platform)
        cycle += 1

    # Cycle 0 is unlikely starting at the repeating loop. Thus we find the first hash that appears 2 times, and take the first occurrence's cycle as the loop stating point.
    cycle_start = hashes[hash_cycle]
    cycle_len = cycle - cycle_start

    # cycle += cycle_len * ((TOTAL_CYCLES - cycle_start) // cycle_len - 1)
    cycle = TOTAL_CYCLES - (TOTAL_CYCLES - cycle_start) % cycle_len

    while cycle < TOTAL_CYCLES:
        tilt_cycle(platform)
        cycle += 1

    print(calc_north_load(platform))


if __name__ == "__main__":
    main()
