#!/usr/bin/env python3
import collections
import fileinput
import itertools

SIDE_NORTH = 0
SIDE_EAST = 1
SIDE_SOUTH = 2
SIDE_WEST = 3
SIDE_ZENITH = 4
SIDE_NADIR = 5

SIDES = set([SIDE_NORTH, SIDE_EAST, SIDE_SOUTH, SIDE_WEST, SIDE_ZENITH, SIDE_NADIR])

SIDE_OPPOSITE = {
    SIDE_NORTH: SIDE_SOUTH,
    SIDE_SOUTH: SIDE_NORTH,
    SIDE_EAST: SIDE_WEST,
    SIDE_WEST: SIDE_EAST,
    SIDE_ZENITH: SIDE_NADIR,
    SIDE_NADIR: SIDE_ZENITH,
}

DELTA_OPPOSITE = {
    SIDE_NORTH: (0, 1, 0),
    SIDE_SOUTH: (0, -1, 0),
    SIDE_EAST: (1, 0, 0),
    SIDE_WEST: (-1, 0, 0),
    SIDE_ZENITH: (0, 0, 1),
    SIDE_NADIR: (0, 0, -1),
}

DELTA_PARALELLS = {
    SIDE_NORTH: [(-1, 0, 0), (1, 0, 0), (0, 0, -1), (0, 0, 1)],
    SIDE_SOUTH: [(-1, 0, 0), (1, 0, 0), (0, 0, -1), (0, 0, 1)],
    SIDE_EAST: [(0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)],
    SIDE_WEST: [(0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)],
    SIDE_ZENITH: [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0)],
    SIDE_NADIR: [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0)],
}


def droplet_scan():
    return [tuple(int(c) for c in line.split(",")) for line in fileinput.input()]


def opposite_droplet_side(droplet, side):
    side_o = SIDE_OPPOSITE[side]
    droplet_o = tuple(a + d for a, d in zip(droplet, DELTA_OPPOSITE[side]))
    return (droplet_o, side_o)


def droplet_sides_self_neighbors(droplet, side):
    return [
        (droplet, side_other) for side_other in SIDES - set([side, SIDE_OPPOSITE[side]])
    ]


def droplet_sides_parallel(droplet, side):
    droplet_sides_other = [
        tuple((a + d for a, d in zip(droplet, delta)), side)
        for delta in DELTA_PARALELLS
    ]
    return droplet_sides_other


def droplet_sides_perpendicular(droplet, side):
    pass  # TODO


def surface_area(droplet_sides, seen, droplet_start, side_start):
    print(f"\n###### surface_area({droplet_start=}, {side_start=})")

    queue = collections.deque([(droplet_start, side_start)])
    area = 1
    while queue:
        droplet_side = queue.popleft()
        droplet, side = droplet_side
        if droplet_side not in droplet_sides or droplet_side in seen:
            continue
        seen.add(droplet_side)

        if opposite_droplet_side(droplet_start, side_start) in droplet_sides:
            print(f"Current {droplet=}, {side=} is not free")
            continue

        area += 1

        # Add same droplet neighbour sides of same droplet to que.
        for droplet_side_sn in droplet_sides_self_neighbors(droplet, side):
            queue.append((droplet_side_sn))

        # Add neighbour droplet sides that are parellel to jump to que.
        for droplet_side_pl in droplet_sides_parallel(droplet, side):
            queue.append(droplet_side_pl)

        # Add neighbour droplet sides that are perpendicular to jump to que.
        for droplet_side_pd in droplet_sides_perpendicular(droplet, side):
            queue.append(droplet_side_pd)

    return area


def main():
    droplets = droplet_scan()
    droplet_sides = [(d, s) for d in droplets for s in SIDES]

    area_max = -1
    seen = set()
    for droplet, side in droplet_sides:
        area = surface_area(droplet_sides, seen, droplet, side)
        area_max = max(area_max, area)
        # break
    print(area_max)


if __name__ == "__main__":
    main()
