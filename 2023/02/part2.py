#!/usr/bin/env python3
import fileinput
from collections import defaultdict
import math


def power(sets):
    counts = defaultdict(int)
    for set in sets:
        cubes = set.split(",")
        for amount, color in map(lambda c: c.strip().split(" "), cubes):
            counts[color] = max(counts[color], int(amount))
    # return reduce(lambda acc, x: acc * x, counts.values())
    return math.prod(counts.values())


def main():
    power_sum = 0
    for line in fileinput.input():
        sets = map(lambda o: o.strip(), line.rstrip("\n").split(":")[1].split(";"))
        power_sum += power(sets)
    print(power_sum)


if __name__ == "__main__":
    main()
