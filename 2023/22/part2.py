#!/usr/bin/env python3
# 101804 too high
import fileinput
from pprint import pprint
from collections import defaultdict, deque
from copy import deepcopy
import heapq

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

    # overlap_x = a_x1 <= b_x1 <= a_x2 or b_x1 <= a_x1 <= b_x2 or a_x1 <= b_x2 <= a_x2 or b_x1 <= a_x2 <= b_x2
    # overlap_y = a_y1 <= b_y1 <= a_y2 or b_y1 <= a_y1 <= b_y2 or a_y1 <= b_y2 <= a_y2 or b_y1 <= a_y2 <= b_y2

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
    falls = 0
    for brick in sorted(bricks, key=lambda b: min(b[0][2], b[1][2])):
        bricks_by_z = group_bricks_by_z(bricks)
        fell = False
        while fall(bricks_by_z, brick):
            fell = True
        if fell:
            falls += 1
    return falls

def calc_brick_supported_by(bricks, bricks_by_z):
    brick_supported_by = defaultdict(int) # brick_id -> int(nbr bricks it is supported by)
    for brick in bricks:
        (x1, y1, z1), (x2, y2, z2), id = brick
        z_min = min(z1, z2)
        for brick_below in bricks_by_z[z_min - 1]:
            if overlaps_xy(brick, brick_below):
                brick_supported_by[id] += 1
    return brick_supported_by

# TODO rename
def brick_without_fallen_supported_by(fallen_bricks, brick, bricks_by_z):
    supported_by = 0
    (x1, y1, z1), (x2, y2, z2), id = brick
    z_min = min(z1, z2)
    for brick_below in bricks_by_z[z_min - 1]:
        if brick_below[2] not in fallen_bricks and overlaps_xy(brick, brick_below):
            supported_by += 1

    return supported_by

def disintegration_falls(bricks, brick):
    bricks_by_z = group_bricks_by_z(bricks)
    brick_supported_by = calc_brick_supported_by(bricks, bricks_by_z)

    b_z_min = min(brick[0][2], brick[1][2])
    fallen_bricks = set([brick[2]]) # brick IDs
    falling = [(b_z_min, brick)]
    while falling:
        # print(len(falling))
        falling_brick = heapq.heappop(falling)[1]
        # if falling_brick[2] in fallen_bricks:
        #     continue
        # print(f"# Falling brick {id2name(falling_brick[2])}") # TODO there seems to be an infinite loop
        (x1, y1, z1), (x2, y2, z2), id = falling_brick
        fb_z_max = max(z1, z2)
        for brick_above in bricks_by_z[fb_z_max + 1]:
            # if overlaps_xy(brick, brick_above): # TODO why is this not true anymore for brick B with above being D/E?
            #     print(f"## Brick {id2name(brick_above[2])} is overlapping")
            # spprt = brick_without_fallen_supported_by(fallen_bricks, brick_above, bricks_by_z)
            # print(f"## Brick {id2name(brick_above[2])} above is supported from below by {spprt} bricks")

            # TODO why is this not true anymore for brick B with above being D/E?
            # if overlaps_xy(brick, brick_above) and brick_without_fallen_supported_by(fallen_bricks, brick_above, bricks_by_z) == 0:
            if  brick_without_fallen_supported_by(fallen_bricks, brick_above, bricks_by_z) == 0:
                # print(f"## Brick {id2name(brick_above[2])} above is no longer supported.")
                if brick_above[2] not in fallen_bricks:
                    fallen_bricks.add(brick_above[2])
                    ba_z_min = min(brick_above[0][2], brick_above[1][2])
                    heapq.heappush(falling, (ba_z_min, brick_above))
            # else:
            #     print(f"## Brick {id2name(brick_above[2])} above is still supported.")
    return len(fallen_bricks) - 1


def main():
    bricks = read_bricks()
    settle_bricks(bricks)
    # print_bricks(bricks)

    total_falls = 0
    for brick in bricks:
        falls = disintegration_falls(bricks, brick)
        print(f"Disintegrating brick {id2name(brick[2])} causes {falls} bricks to fall.")
        total_falls += falls
    print(total_falls)

    # total_falls = 0
    # for i in range(len(bricks)):
    #     bricksc = deepcopy(bricks)
    #     del bricksc[i]
    #     falls = settle_bricks(bricksc)
    #     print(f"Disintegrating brick {id2name(bricks[i][2])} causes {falls} bricks to fall.")
    #     total_falls += falls
    # print(total_falls)

if __name__ == '__main__':
	main()
