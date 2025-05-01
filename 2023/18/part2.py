#!/usr/bin/env python3
import fileinput

DIR_DELTA = {
    0: (0, 1),
    1: (1, 0),
    2: (0, -1),
    3: (-1, 0),
}


def find_trench_loop():
    trench_loop: list[complex] = []

    x, y = 0, 0
    for line in fileinput.input():
        rgb = line.rstrip("\n").split()[-1].strip("(#)")
        meters, dir = (int(x, 16) for x in (rgb[:-1], rgb[-1]))
        delta = DIR_DELTA[dir]

        x, y = x + delta[0] * meters, y + delta[1] * meters
        trench_loop.append((x, y))

    return trench_loop


def loop_length(loop):
    len = 0
    pairs = tuple(zip(loop, loop[1:] + [loop[0]]))
    for (x1, y1), (x2, y2) in pairs:
        len += abs(x2 - x1) + abs(y2 - y1)  # Manhattan distance
    return len


def polygon_area(loop):
    # https://en.wikipedia.org/wiki/Shoelace_formula
    pairs = tuple(zip(loop, loop[1:] + [loop[0]]))
    # abs() because of loop orientation might be backwards.
    return 0.5 * abs(sum((y1 + y2) * (x1 - x2) for (x1, y1), (x2, y2) in pairs))


def cubic_meters_contained(loop):
    """
    We can use https://en.wikipedia.org/wiki/Pick%27s_theorem.
    A = i + b/2 - 1 (1)
    Note that the result we look for is actually not the area A but the total number of points i.e.
    i + b (2)
    which we can get i with (1) as
    i = A - b/2 + 1 (3)
    Plugging (3) in to (2):
    i + b = A - b/2 + 1 + b = A + b/2 + 1
    We can use the shoelace area to find A, and b is just the loop length.
    """
    b = loop_length(loop)
    A = polygon_area(loop)
    return int(A + b / 2 + 1)


def main():
    trench_loop = find_trench_loop()
    area = cubic_meters_contained(trench_loop)
    print(area)


if __name__ == "__main__":
    main()
