#!/usr/bin/env python3
import re
import sys

TILE_OPEN = "."
TILE_WALL = "#"
TILE_CLOSED = " "

TURN_LEFT = "L"
TURN_RIGHT = "R"

DIR_U = -1
DIR_R = 1j
DIR_D = 1
DIR_L = -1j

DIRS = [DIR_R, DIR_D, DIR_L, DIR_U]

DIR_SYM = {
    DIR_U: "^",
    DIR_R: ">",
    DIR_D: "v",
    DIR_L: "<",
}

DIR_CLOCKWISE = -1j
DIR_CCLOCKWISE = 1j
DIR_FACT = {TURN_RIGHT: DIR_CLOCKWISE, TURN_LEFT: DIR_CCLOCKWISE}


def read_input():
    # str_map, str_steps = open(sys.argv[1]).read().split("\n\n")
    # map = str_map.split("\n")
    *map, _, str_steps = open(sys.argv[1])
    map = [r.rstrip("\n") for r in map]
    steps = [int(s) if s.isdigit() else s for s in re.findall(r"\d+|[LR]", str_steps)]
    pos_start = complex(0, map[0].index(TILE_OPEN))
    dir = DIR_R
    return map, steps, pos_start, dir


def pad_map(map):
    mapp = []
    col_maxlen = max(len(r) for r in map)
    for row in map:
        if len(row) < col_maxlen:
            pad = col_maxlen - len(row)
            mapp.append(row + TILE_CLOSED * pad)
        else:
            mapp.append(row)
    return mapp


def print_map(map, path=[]):
    visited = {pos: dir for pos, dir in path}
    for row in range(len(map)):
        assert len(map[row]) == len(map[0])
        for col in range(len(map[0])):
            pos = complex(row, col)
            if pos in visited:
                print(DIR_SYM[visited[pos]], end="")
            else:
                print(map[row][col], end="")
        print()


def tile(map, pos):
    return map[int(pos.real)][int(pos.imag)]


def wrap(map, pos, dir):
    row_len = len(map)
    col_len = len(map[0])

    # Check if wrap-around is needed.
    if (
        (0 <= pos.real < row_len)
        and (0 <= pos.imag < col_len)
        and tile(map, pos) != TILE_CLOSED
    ):
        return pos

    # We're lucky, only simple wraps exist in input. Not "...   B..A""  cases
    if dir == DIR_U:
        pos = complex(row_len - 1, pos.imag)
    elif dir == DIR_R:
        pos = complex(pos.real, 0)
    elif dir == DIR_D:
        pos = complex(0, pos.imag)
    else:
        pos = complex(pos.real, col_len - 1)

    while tile(map, pos) == TILE_CLOSED:
        pos += dir

    return pos


def main():
    map, steps, pos, dir = read_input()
    map = pad_map(map)

    path = [(pos, dir)]

    for step in steps:
        match step:
            case int():
                for _ in range(step):
                    pos_n = pos + dir
                    pos_n = wrap(map, pos_n, dir)

                    # Break if next tile would be a wall.
                    if tile(map, pos_n) == TILE_WALL:
                        break

                    # Else step ahead!
                    pos = pos_n
                    path.append((pos, dir))

            case str():
                dir *= DIR_FACT[step]
        path.append((pos, dir))

    # print_map(map, path)

    password = 1000 * int(pos.real + 1) + 4 * int(pos.imag + 1) + DIRS.index(dir)
    print(password)


if __name__ == "__main__":
    main()
