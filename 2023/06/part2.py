#!/usr/bin/env python3
import fileinput

from lib import win_possibilities


def read_race():
    return [int(l.split(":")[1].replace(" ", "")) for l in fileinput.input()]


def main():
    time, record_distance = read_race()
    wins = win_possibilities(time, record_distance)
    print(wins)


if __name__ == "__main__":
    main()
