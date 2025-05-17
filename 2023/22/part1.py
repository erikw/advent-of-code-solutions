#!/usr/bin/env python3
import fileinput
from pprint import pprint
from collections import defaultdict

SYM_EMPTY = "."
SYM_HIDDEN = "?"

def read_bricks():
    bricks = []
    # for line in fileinput.input():
    for i, line in enumerate(fileinput.input()):
        brick = tuple(list(map(int, p.split(","))) for p in line.rstrip("\n").split("~"))
        brick = [list(map(int, p.split(","))) for p in line.rstrip("\n").split("~")]
        brick.extend(chr(i + ord('A')))
        bricks.append(brick)
    return bricks


def print_bricks_side(bricks, side):
    ss = [s for t in map(lambda b: (b[0][side], b[1][side]), bricks) for s in t]
    zs = [z for t in map(lambda b: (b[0][2], b[1][2]), bricks) for z in t]
    s_min, s_max = min(ss), max(ss)
    z_min, z_max = min(zs), max(zs)
    len_s = max(ss) - min(ss) + 1
    len_z = max(zs) - min(zs) + 1

    bricks_by_z = defaultdict(list)
    for brick in bricks:
        p1, p2, _name = brick
        bz_min, bz_max = min(p1[2], p2[2]), max(p1[2], p2[2])
        for z in range(bz_min, bz_max + 1):
            bricks_by_z[z].append(brick)

    # Print view S-axis
    print(" " * (len_s//2) + ("x" if side == 0 else "y") + " " * (len_s//2))
    s_axis = []
    for s in range(s_min, s_max + 1):
        s_axis.append(str(s))
    print("".join(s_axis))

    for z in range(z_max, z_min - 1, -1):
        line = []
        for s in range(s_min, s_max + 1):
            bricks_present = []
            for brick in bricks_by_z[z]:
                bs_min = min(brick[0][side], brick[1][side])
                bs_max = max(brick[0][side], brick[1][side])
                if bs_min <= s <= bs_max:
                    bricks_present.append(brick[2])
            match len(bricks_present):
                case 0:
                    line.append(SYM_EMPTY)
                case 1:
                    line.append(bricks_present[0])
                case _:
                    line.append(SYM_HIDDEN)
        line.append(f" {z}")
        if z == len_z//2 + 1:
            line.append(f" z")
        print("".join(line))
    print("-" * len_s + " 0")


def print_bricks(bricks):
    print_bricks_side(bricks, 0)
    print("\n")
    print_bricks_side(bricks, 1)


def settle_bricks(bricks_snapshot):
    ...

def main():
    bricks_snapshot = read_bricks()
    print_bricks(bricks_snapshot)

    # bricks_settled = settle_bricks(bricks_snapshot)
    # pprint(bricks_settled)

if __name__ == '__main__':
	main()
