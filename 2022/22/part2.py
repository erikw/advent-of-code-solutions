#!/usr/bin/env python3
import re
import sys
from enum import Enum

TILE_OPEN = "."
TILE_WALL = "#"
TILE_CLOSED = " "

TURN_LEFT = "L"
TURN_RIGHT = "R"


class Dir(Enum):
    UP = -1
    RIGHT = 1j
    DOWN = 1
    LEFT = -1j


DIR_SYM = {
    Dir.UP: "^",
    Dir.RIGHT: ">",
    Dir.DOWN: "v",
    Dir.LEFT: "<",
}

DIR_CLOCKWISE = -1j
DIR_CCLOCKWISE = 1j
DIR_FACT = {TURN_RIGHT: DIR_CLOCKWISE, TURN_LEFT: DIR_CCLOCKWISE}


DIRS = [Dir.RIGHT, Dir.DOWN, Dir.LEFT, Dir.UP]


def read_input():
    *map, _, str_steps = open(sys.argv[1])
    map = [r.rstrip("\n") for r in map]
    steps = [int(s) if s.isdigit() else s for s in re.findall(r"\d+|[LR]", str_steps)]
    pos_start = complex(0, map[0].index(TILE_OPEN))
    dir = Dir.RIGHT.value
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
                print(DIR_SYM[Dir(visited[pos])], end="")
            else:
                print(map[row][col], end="")
        print()


def tile(map, pos):
    return map[int(pos.real)][int(pos.imag)]


def wrap(map, pos, dir):
    row = int(pos.real)
    col = int(pos.imag)

    # Check if wrap-around is needed.
    if (
        (0 <= row < len(map))
        and (0 <= col < len(map[0]))
        and tile(map, pos) != TILE_CLOSED
    ):
        return pos, dir

    # Not a general solution; hardcoded to the shape of my input.
    # h/t https://www.reddit.com/r/adventofcode/comments/zsct8w/comment/j17k7nn/
    # Tip: acutally fold a piece of paper and number the regions.
    match Dir(dir), row // 50, col // 50:
        case Dir.RIGHT, 0, _:
            return complex(149 - row, 99), Dir.LEFT.value
        case Dir.RIGHT, 1, _:
            return complex(49, row + 50), Dir.UP.value
        case Dir.RIGHT, 2, _:
            return complex(149 - row, 149), Dir.LEFT.value
        case Dir.RIGHT, 3, _:
            return complex(149, row - 100), Dir.UP.value
        case Dir.LEFT, 0, _:
            return complex(149 - row, 0), Dir.RIGHT.value
        case Dir.LEFT, 1, _:
            return complex(100, row - 50), Dir.DOWN.value
        case Dir.LEFT, 2, _:
            return complex(149 - row, 50), Dir.RIGHT.value
        case Dir.LEFT, 3, _:
            return complex(0, row - 100), Dir.DOWN.value
        case Dir.DOWN, _, 0:
            return complex(0, col + 100), Dir.DOWN.value
        case Dir.DOWN, _, 1:
            return complex(100 + col, 49), Dir.LEFT.value
        case Dir.DOWN, _, 2:
            return complex(-50 + col, 99), Dir.LEFT.value
        case Dir.UP, _, 0:
            return complex(50 + col, 50), Dir.RIGHT.value
        case Dir.UP, _, 1:
            return complex(100 + col, 0), Dir.RIGHT.value
        case Dir.UP, _, 2:
            return complex(199, col - 100), Dir.UP.value
        case _:
            raise "Ended up in unexpected side of the cube :O"


def main():
    map, steps, pos, dir = read_input()
    map = pad_map(map)

    path = [(pos, dir)]

    for step in steps:
        match step:
            case str():
                dir *= DIR_FACT[step]
            case int():
                for _ in range(step):
                    pos_n = pos + dir
                    pos_n, dir_n = wrap(map, pos_n, dir)

                    # Break if next tile would be a wall.
                    if tile(map, pos_n) == TILE_WALL:
                        break

                    # Else step ahead!
                    pos = pos_n
                    dir = dir_n
                    path.append((pos, dir))

        path.append((pos, dir))

    # print_map(map, path)

    password = 1000 * int(pos.real + 1) + 4 * int(pos.imag + 1) + DIRS.index(Dir(dir))
    print(password)


if __name__ == "__main__":
    main()
