#!/usr/bin/env python3
import fileinput
import re


def extract_numbers(line):
    return [int(d) for d in re.findall(r"\d+(?:\s|$)", line)]


def nbr_points(line):
    nbrs_winning, nbrs_mine = (set(extract_numbers(ns)) for ns in line.split("|"))
    wins = nbrs_winning.intersection(nbrs_mine)
    if wins:
        points = 2 ** (len(wins) - 1)
        return points
    else:
        return 0


def main():
    points = 0
    for line in fileinput.input():
        points += nbr_points(line.rstrip())
    print(points)


if __name__ == "__main__":
    main()
