#!/usr/bin/env python3
import fileinput

SYM_ROCK_ROUND = "O"
SYM_ROCK_CUBE = "#"
SYM_EMPTY = "."


def read_platform():
    return [list(l.rstrip("\n")) for l in fileinput.input()]


def print_platform(platform):
    for row in platform:
        print("".join(row))


def roll_north(platform, row, col):
    while row > 0 and platform[row - 1][col] == SYM_EMPTY:
        platform[row - 1][col] = SYM_ROCK_ROUND
        platform[row][col] = SYM_EMPTY
        row -= 1


def tilt_north(platform):
    for row in range(len(platform)):
        for col in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                roll_north(platform, row, col)


def calc_north_load(platform):
    load = 0
    for row in range(len(platform)):
        for col in range(len(platform)):
            if platform[row][col] == SYM_ROCK_ROUND:
                load += len(platform) - row
    return load


def main():
    platform = read_platform()
    tilt_north(platform)
    print(calc_north_load(platform))


if __name__ == "__main__":
    main()
