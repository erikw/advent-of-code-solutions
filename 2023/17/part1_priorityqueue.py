#!/usr/bin/env python3
# PriorityQueue version.
# h/t https://www.reddit.com/r/adventofcode/comments/18k9ne5/comment/kdq86mr/

import fileinput
from pprint import pprint
from queue import PriorityQueue
from dataclasses import dataclass, field
from typing import Any

from termcolor import colored


@dataclass(order=True)
class PrioritizedItem:
    priority: int
    item: Any=field(compare=False)


NEIGHBOR_DIRECTIONS = {-1, 1, -1j, 1j}

DIR2SYM = {
    -1: "^",
    1: "v",
    -1j: "<",
    1j: ">",
}


def read_heat_map():
    return {complex(i, j): int(c) for i, l in enumerate(fileinput.input()) for j, c in enumerate(l.rstrip("\n"))}


def print_map_path(heat_map, path):
    path_dir = {p: d for p, d in path}
    rows = int(max(p.real for p in heat_map)) + 1
    cols = int(max(p.imag for p in heat_map)) + 1
    for row in range(rows):
        for col in range(cols):
            pos = complex(row, col)
            if pos != 0 and pos in path_dir:
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
def constrained_dijkstra(heat_map, pos_start, pos_end):
    que = PriorityQueue()  # PrioritizedItem(dist, (pos, dir, [prev]))
    visited = set() # (pos, dir)

    que.put(PrioritizedItem(0, (pos_start, 0, [])))
    while not que.empty():
        prio_item = que.get()
        dist = prio_item.priority
        pos, dir, prev = prio_item.item

        if pos == pos_end:
            # break
            prev.append((pos, dir))
            return dist, prev
        if (pos, dir) in visited:
             continue
        visited.add((pos, dir))

        # Only look sideways, not backwards or forward (as forward is taken care by the for steps .. below)
        for ndir in NEIGHBOR_DIRECTIONS - {dir, -dir}:
            npos = pos
            ndist = dist

            nprev = prev.copy()
            ndir_prev = dir

            for _steps in range(3):
                npos += ndir
                if not npos in heat_map:
                    break

                ndist += heat_map[npos]

                nprev.append((npos-ndir, ndir_prev))
                ndir_prev = ndir

                # PriorityQueue does not have a decrease_priority(). Thus,
                # insert duplicate with lower distance. Then use a visited set
                # to prevent the original with higher distance from being
                # selected later.
                que.put(PrioritizedItem(ndist, (npos, ndir, nprev.copy())))

    return None, None


def main():
    heat_map = read_heat_map()
    pos_lava_pool = 0
    pos_factory = max(heat_map, key=abs)

    heat_loss, path = constrained_dijkstra(heat_map, pos_lava_pool, pos_factory)

    # print_map_path(heat_map, path)
    print(heat_loss)

if __name__ == '__main__':
	main()