#!/usr/bin/env python3
import fileinput
from functools import reduce

DELTAS = [
    (-1, 0, 0),
    (1, 0, 0),
    (0, -1, 0),
    (0, 1, 0),
    (0, 0, -1),
    (0, 0, 1),
]


def droplet_scan():
    return [tuple(int(c) for c in line.split(",")) for line in fileinput.input()]


def neighbours(droplet):
    return set([tuple(a + b for a, b in zip(droplet, delta)) for delta in DELTAS])


def minmax(items):
    return reduce(
        lambda acc, x: (min(acc[0], x), max(acc[1], x)), items, (items[0], items[0])
    )


def main():
    droplets = droplet_scan()

    x_min, x_max = minmax([x for x, _, _ in droplets])
    y_min, y_max = minmax([y for _, y, _ in droplets])
    z_min, z_max = minmax([z for _, _, z in droplets])

    def in_bounds(x, y, z):
        return (
            x_min - 1 <= x <= x_max + 1
            and y_min - 1 <= y <= y_max + 1
            and z_min - 1 <= z <= z_max + 1
        )

    # Starting point somewhere outside lava.
    stack = [(x_min - 1, y_min - 1, z_min - 1)]
    seen = set()

    # DFS explore droplets outside the lava that are within bounds of the lava.
    # h/t https://www.reddit.com/r/adventofcode/comments/zoqhvy/comment/j0oul0u/
    while stack:
        droplet = stack.pop()
        seen.add(droplet)
        for droplet_n in neighbours(droplet):
            if (
                in_bounds(*droplet_n)
                and droplet_n not in droplets
                and droplet_n not in seen
            ):
                assert droplet_n not in seen
                stack.append(droplet_n)

    # Count how many found the dropelts are actual neighbours of the lava.
    sides = 0
    for droplet in droplets:
        for droplet_n in neighbours(droplet):
            if droplet_n in seen:
                sides += 1
    print(sides)


if __name__ == "__main__":
    main()
