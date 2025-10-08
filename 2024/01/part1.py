#!/usr/bin/env python3
import fileinput
import re


def read_input():
    left = []
    right = []
    for line in fileinput.input():
        l, r = [int(n) for n in re.findall(r"\d+", line)]
        left.append(l)
        right.append(r)
    return left, right


def main():
    left, right = read_input()

    dist = 0
    for l, r in zip(sorted(left), sorted(right)):
        dist += abs(l - r)
    print(dist)


if __name__ == "__main__":
    main()
