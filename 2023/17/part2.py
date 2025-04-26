#!/usr/bin/env python3
# Heapq version.

import fileinput
import heapq

from termcolor import colored

MOVES_MIN = 4
MOVES_MAX = 10

DIR_UP = (-1, 0)
DIR_DOWN = (1, 0)
DIR_LEFT = (0, -1)
DIR_RIGHT = (0, 1)
NEIGHBOR_DIRECTIONS = {DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT}

DIR2SYM = {
    DIR_UP: "^",
    DIR_DOWN: "v",
    DIR_LEFT: "<",
    DIR_RIGHT: ">",
}


def read_heat_map():
    return {(i, j): int(c) for i, l in enumerate(fileinput.input()) for j, c in enumerate(l.rstrip("\n"))}


def print_map_path(heat_map, path, pos_start):
    path_dir = {p: d for p, d in path}
    rows = int(max(p[0] for p in heat_map)) + 1
    cols = int(max(p[1] for p in heat_map)) + 1
    for row in range(rows):
        for col in range(cols):
            pos = (row, col)
            if pos != pos_start and pos in path_dir:
                dir = path_dir[pos]
                csym = colored(DIR2SYM[dir], "red")
                print(csym, end="")
            else:
                print(heat_map[pos], end="")
        print()


# Run (constrained) Dijkstra on the directed weighted graph calculated from
# heat_map. Going from cell A to neighbor B in heat_map has the edge weight of
# heat_map[B].
# https://en.wikipedia.org/wiki/Constrained_Shortest_Path_First
# Important to not have a global dist dict/list when stepping forward 1..2..3 steps like done here as the wrong distance will be recorded and a loop hi-jacking the path will occur.
def constrained_dijkstra(heat_map, pos_start, pos_end, moves_min, moves_max):
    que = [(0, pos_start, (0, 0), [])]  # [(dist, pos, dir, [prev])]
    visited = set() # (pos, dir)

    while que:
        dist, pos, dir, prev = heapq.heappop(que)

        if pos == pos_end:
            prev.append((pos, dir))
            return dist, prev
        if (pos, dir) in visited:
             continue
        visited.add((pos, dir))

        # Only look sideways, not backwards or forward (as forward is taken care by the for steps .. below)
        for ndir in NEIGHBOR_DIRECTIONS - {dir, tuple(-n for n in dir)}:
            npos = pos
            ndist = dist

            nprev = prev.copy()
            ndir_prev = dir

            for steps in range(moves_max):
                pos_prev = npos
                npos = tuple(p+d for p, d in zip(npos, ndir))
                if not npos in heat_map:
                    break

                ndist += heat_map[npos]

                nprev.append((pos_prev, ndir_prev))
                ndir_prev = ndir

                if (steps + 1) >= moves_min:
                    # heap does not have a decrease_priority(). Thus,
                    # insert duplicate with lower distance. Then use a visited set
                    # to prevent the original with higher distance from being
                    # selected later.
                    heapq.heappush(que, (ndist, npos, ndir, nprev.copy()))

    return None, None


def main():
    heat_map = read_heat_map()
    pos_lava_pool = (0, 0)
    pos_factory = max(heat_map)

    heat_loss, path = constrained_dijkstra(heat_map, pos_lava_pool, pos_factory, MOVES_MIN, MOVES_MAX)

    # print_map_path(heat_map, path, pos_lava_pool)
    print(heat_loss)

if __name__ == '__main__':
	main()
