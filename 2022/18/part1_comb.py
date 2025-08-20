#!/usr/bin/env python3
import fileinput
import itertools


def droplet_scan():
    return [tuple(int(c) for c in line.split(",")) for line in fileinput.input()]


def droplets_connected(d1, d2):
    # If the cubes have 2 coordinates in common, and the other is max 1 in difference.
    return (
        sum([x == y for (x, y) in zip(d1, d2)]) == 2
        and sum([abs(x - y) for x, y in zip(d1, d2)]) == 1
    )


def main():
    droplets = droplet_scan()
    sides = len(droplets) * 6
    sides_connected = 0

    for d1, d2 in itertools.combinations(droplets, 2):
        if droplets_connected(d1, d2):
            sides_connected += 2

    area = int(sides - sides_connected)
    print(area)


if __name__ == "__main__":
    main()
