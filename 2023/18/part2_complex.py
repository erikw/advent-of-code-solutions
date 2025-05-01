#!/usr/bin/env python3
# Version using complex coordinates.
import fileinput

DIR_RIGHT = 0
DIR_DOWN = 1
DIR_LEFT = 2
DIR_UP = 3

DIR_DELTA = {
    DIR_RIGHT: 1j,
    DIR_DOWN: 1,
    DIR_LEFT: -1j,
    DIR_UP: -1,
}


def find_trench_loop():
    trench_loop: list[complex] = []

    pos = 0
    for line in fileinput.input():
        rgb = line.rstrip("\n").split()[-1].strip("(#)")
        meters, dir = (int(x, 16) for x in (rgb[:-1], rgb[-1]))
        delta = DIR_DELTA[dir]

        pos += delta * meters
        trench_loop.append(pos)

    return trench_loop


def loop_length(loop):
    len = 0
    pairs = tuple(zip(loop, loop[1:] + [loop[0]]))
    for p1, p2 in pairs:
        len += abs(p2.real - p1.real) + abs(p2.imag - p1.imag)  # Manhattan distance
    return len


def polygon_area(loop):
    # https://en.wikipedia.org/wiki/Shoelace_formula
    pairs = tuple(zip(loop, loop[1:] + [loop[0]]))
    # abs() because of loop orientation might be backwards.
    return 0.5 * abs(sum((p1.imag + p2.imag) * (p1.real - p2.real) for p1, p2 in pairs))


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
