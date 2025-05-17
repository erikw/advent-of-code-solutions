#!/usr/bin/env python3
import fileinput
from pprint import pprint
from collections import defaultdict

SYM_EMPTY = "."
SYM_HIDDEN = "?"

def read_bricks():
    bricks = []
    for i, line in enumerate(fileinput.input()):
        brick = tuple(list(map(int, p.split(","))) for p in line.rstrip("\n").split("~"))
        brick = [list(map(int, p.split(","))) for p in line.rstrip("\n").split("~")]
        brick.append(i)
        bricks.append(brick)
    return bricks


def group_bricks_by_z(bricks):
    bricks_by_z = defaultdict(list)
    for brick in bricks:
        p1, p2, _id = brick
        z_min, z_max = min(p1[2], p2[2]), max(p1[2], p2[2])
        for z in range(z_min, z_max + 1):
            bricks_by_z[z].append(brick)
    return bricks_by_z


def extract_coordinate(bricks, axis):
    az = [a for t in map(lambda b: (b[0][axis], b[1][axis]), bricks) for a in t]
    a_min, a_max = min(az), max(az)
    a_len = max(az) - min(az) + 1
    return az, a_min, a_max, a_len


def id2name(id):
    return chr(id + ord('A'))

def brick_name(brick):
    return id2name(brick[2])

def print_bricks_side(bricks, axis):
    _ss, s_min, s_max, s_len = extract_coordinate(bricks, axis)
    _zs, z_min, z_max, z_len = extract_coordinate(bricks, 2)
    bricks_by_z = group_bricks_by_z(bricks)

    # Print view S-axis
    print(" " * (s_len//2) + ("x" if axis == 0 else "y") + " " * (s_len//2))
    s_axis = []
    for s in range(s_min, s_max + 1):
        s_axis.append(str(s))
    print("".join(s_axis))

    for z in range(z_max, z_min - 1, -1):
        line = []
        for s in range(s_min, s_max + 1):
            bricks_present = []
            for brick in bricks_by_z[z]:
                bs_min = min(brick[0][axis], brick[1][axis])
                bs_max = max(brick[0][axis], brick[1][axis])
                if bs_min <= s <= bs_max:
                    bricks_present.append(brick[2])
            match len(bricks_present):
                case 0:
                    line.append(SYM_EMPTY)
                case 1:
                    line.append(id2name(bricks_present[0]))
                case _:
                    line.append(SYM_HIDDEN)
        line.append(f" {z}")
        if z == z_len//2 + 1:
            line.append(f" z")
        print("".join(line))
    print("-" * s_len + " 0")


def print_bricks(bricks):
    print_bricks_side(bricks, 0)
    print("")
    print_bricks_side(bricks, 1)

def overlaps_xy(brick_a, brick_b):
    (a_x1, a_y1, _a_z1), (a_x2, a_y2, _a_z2), _a_id = brick_a
    (b_x1, b_y1, _b_z1), (b_x2, b_y2, _b_z2), _b_id = brick_b

    overlap_x = a_x1 <= b_x1 <= a_x2 or b_x1 <= a_x1 <= b_x2
    overlap_y = a_y1 <= b_y1 <= a_y2 or b_y1 <= a_y1 <= b_y2

    return overlap_x and overlap_y

def fall(bricks_by_z, brick):
    (_x1, _y1, z1), (_x2, _y2, z2), _id = brick
    z_min = min(z1, z2)
    if z_min == 1:
        return False

    for brick_below in bricks_by_z[z_min - 1]:
        if overlaps_xy(brick, brick_below):
            return False

    brick[0][2] -= 1
    brick[1][2] -= 1
    return True

def settle_bricks(bricks):
    for brick in sorted(bricks, key=lambda b: min(b[0][2], b[1][2])):
        bricks_by_z = group_bricks_by_z(bricks)
        while fall(bricks_by_z, brick):
            pass

def calc_brick_supported_by(bricks, bricks_by_z):
    brick_supported_by = defaultdict(int) # brick_id -> int(nbr bricks it is supported by)
    for brick in bricks:
        (x1, y1, z1), (x2, y2, z2), id = brick
        z_min = min(z1, z2)
        for brick_below in bricks_by_z[z_min - 1]:
            if overlaps_xy(brick, brick_below):
                brick_supported_by[id] += 1
    return brick_supported_by


def disintegration_safe(bricks):
    bricks_by_z = group_bricks_by_z(bricks)
    brick_supported_by = calc_brick_supported_by(bricks, bricks_by_z)

    safe_bricks = []
    for brick in bricks:
        (x1, y1, z1), (x2, y2, z2), id = brick
        z_max = max(z1, z2)
        safe = True
        for brick_above in bricks_by_z[z_max + 1]:
            if overlaps_xy(brick, brick_above) and brick_supported_by[brick_above[2]] == 1:
                safe = False
                break
        if safe:
            safe_bricks.append(brick)
    return safe_bricks


def main():
    bricks = read_bricks()
    # print_bricks(bricks)

    settle_bricks(bricks)
    # print("\n==== After settling:")
    # print_bricks(bricks)

    bricks_safe = disintegration_safe(bricks)
    print(len(bricks_safe))

if __name__ == '__main__':
	main()
