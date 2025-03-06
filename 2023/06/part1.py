#!/usr/bin/env python3
import fileinput
import re
from math import prod

from lib import win_possibilities


def read_races():
    data = [[int(d) for d in re.findall(r"\d+", l)] for l in fileinput.input()]
    return zip(*data)


def main():
    races = read_races()
    wins = prod(win_possibilities(t, d) for t, d in races)
    print(wins)


if __name__ == "__main__":
    main()
