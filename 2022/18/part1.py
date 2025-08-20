#!/usr/bin/env python3
import fileinput


def droplet_scan():
    return [tuple(int(c) for c in line.split(",")) for line in fileinput.input()]


DELTAS = [
    (-1, 0, 0),
    (1, 0, 0),
    (0, -1, 0),
    (0, 1, 0),
    (0, 0, -1),
    (0, 0, 1),
]


def neighbours(droplet):
    for delta in DELTAS:
        yield tuple(a + b for a, b in zip(droplet, delta))


def main():
    droplets = droplet_scan()
    sides = sum(dn not in droplets for d in droplets for dn in neighbours(d))
    print(sides)


if __name__ == "__main__":
    main()
