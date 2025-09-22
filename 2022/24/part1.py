#!/usr/bin/env python3
import fileinput
import heapq
from collections import defaultdict

SYM_WALL = "#"
SYM_GROUND = "."
SYM_EXP = "E"
SYM_BLIZZARDS = ["^", "v", "<", ">"]


DIR_UP = -1 + 0j
DIR_DOWN = 1 + 0j
DIR_LEFT = 0 + -1j
DIR_RIGHT = 0 + 1j

DIRS = [DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT]

BLIZSYM2DIR = {"^": DIR_UP, "v": DIR_DOWN, "<": DIR_LEFT, ">": DIR_RIGHT}
DIR2BLIZSYM = {d: s for s, d in BLIZSYM2DIR.items()}


def read_input():
    map = {}
    lines = [line.rstrip("\n") for line in fileinput.input()]
    row_len = len(lines)
    col_len = len(lines[0])
    blizzards = defaultdict(list)  # pos -> [dir]
    for row, line in enumerate(lines):
        for col, sym in enumerate(line):
            pos = complex(row, col)
            if sym in SYM_BLIZZARDS:
                blizzards[pos].append(BLIZSYM2DIR[sym])
                # Keep the map only representing the valley and avoid updating it as things moves
                sym = SYM_GROUND
            map[pos] = sym
    pos_start = complex(0, lines[0].index(SYM_GROUND))
    pos_end = complex(row_len - 1, lines[-1].index(SYM_GROUND))
    return map, row_len, col_len, blizzards, pos_start, pos_end


def print_map(map, row_len, col_len, blizzards, title=""):
    if title:
        print(title)
    for row in range(row_len):
        for col in range(col_len):
            pos = complex(row, col)
            if pos in blizzards:
                if len(blizzards[pos]) == 1:
                    print(DIR2BLIZSYM[blizzards[pos][0]], end="")
                else:
                    print(len(blizzards[pos]), end="")
            else:
                print(map[pos], end="")
        print()
    print()


def wrap(map, row_len, col_len, pos, dir):
    if map[pos] != SYM_WALL:
        return pos
    elif dir == DIR_UP:
        return complex(row_len - 2, pos.imag)
    elif dir == DIR_DOWN:
        return complex(1, pos.imag)
    elif dir == DIR_LEFT:
        return complex(pos.real, col_len - 2)
    else:
        return complex(pos.real, 1)


# Note: position here is not only in space but in time as well..
def dijkstra(edges, pos_start, pos_end):
    pq = [(0, pos_start)]  # (dist, (row, col, min))
    dists = defaultdict(lambda: float("inf"))
    dists[pos_start] = 0
    visited = set()

    while pq:
        dist, pos = heapq.heappop(pq)
        if pos in visited:
            continue
        elif pos == pos_end:
            return dists[pos]

        visited.add(pos)

        for pos_n in edges[pos]:
            dist_alt = dist + (0 if pos_n == pos_end else 1)
            if dist_alt < dists[pos_n]:
                dists[pos_n] = dist_alt
                heapq.heappush(pq, (dist_alt, pos_n))

    assert False


# Discrete version
def cm2t(cmplx, min):
    return (int(cmplx.real), int(cmplx.imag), min)


def main():
    map, row_len, col_len, blizzards_init, pos_start, pos_end = read_input()
    # print_map(map, row_len, col_len, blizzards, "Initial state:")

    mins_period = 0
    blizzards_min = [blizzards_init.copy()]  # Blizzard positions at time min.
    while True:
        mins_period += 1
        blizzards = defaultdict(list)
        for pos_bliz, dirs in blizzards_min[-1].items():
            for dir in dirs:
                pos_n = pos_bliz + dir
                pos_n = wrap(map, row_len, col_len, pos_n, dir)
                blizzards[pos_n].append(dir)
        if blizzards == blizzards_min[0]:
            break
        blizzards_min.append(blizzards)
        # time.sleep(0.5)
        # print_map(map, row_len, col_len, blizzards, f"Minute {mins_period}, <action>:")

    # Create a residual space-time graph.
    edges = defaultdict(list)  # (pos, min) -> [(pos_n, min_n)]
    for min in range(mins_period):
        min_next = (min + 1) % mins_period
        for pos, sym in map.items():
            if sym == SYM_WALL:
                continue

            if pos == pos_end:
                # Edge to artificial collecting final node.
                edges[cm2t(pos, min)].append(cm2t(pos, -1))

            # Action: wait, if spot is blizzard-free the next minute.
            if pos not in blizzards_min[min_next]:
                edges[cm2t(pos, min)].append(cm2t(pos, min_next))

            # Action: move to neighbour that is free the next minute.
            for dir in DIRS:
                pos_n = pos + dir
                if (
                    0 <= pos_n.real < row_len
                    and 0 <= pos.imag < col_len
                    and map[pos_n] != SYM_WALL
                    and pos_n not in blizzards_min[min_next]
                ):
                    edges[cm2t(pos, min)].append(cm2t(pos_n, min_next))

    mins = dijkstra(edges, cm2t(pos_start, 0), cm2t(pos_end, -1))
    print(mins)


if __name__ == "__main__":
    main()
