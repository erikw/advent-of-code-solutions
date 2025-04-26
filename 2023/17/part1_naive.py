#!/usr/bin/env python3
# NOPE Constraint as added here prevents discovery of the right path coming form different a direction.
import fileinput
from pprint import pprint
from queue import PriorityQueue
from collections import defaultdict

from dataclasses import dataclass, field
from typing import Any


@dataclass(order=True)
class PrioritizedItem:
    priority: int
    item: Any=field(compare=False)


NEIGHBOR_DIRECTIONS = [ -1, 1, -1j, 1j]

DIR2SYM = {
    -1: "^",
    1: "v",
    -1j: "<",
    1j: ">",
}


def read_heat_map():
#     return tuple(tuple(map(int, list(l.rstrip("\n")))) for l in fileinput.input())
    heat_map = {}
    rows = list(fileinput.input())
    for row, line in enumerate(rows):
        for col, c in enumerate(line.rstrip("\n")):
            heat_map[complex(row, col)] = int(c)
    return heat_map, len(rows), len(rows[0]) - 1


# def print_map_path(heat_map, rows, cols, prev):
#     prev_pos_dir = {p: d for p, d in prev.values()}
#     for row in range(rows):
#         for col in range(cols):
#             pos = complex(row, col)
#             if pos == 11+11j:
#                 print("break")
#             if pos in prev_pos_dir:
#                 dir = prev_pos_dir[pos]
#                 print(DIR2SYM[dir], end="")
#             else:
#                 print(heat_map[pos], end="")
#         print()

def print_map_path(heat_map, rows, cols, path):
    path_dir = {p: d for p, d in path}
    for row in range(rows):
        for col in range(cols):
            pos = complex(row, col)
            if pos in path_dir:
                dir = path_dir[pos]
                print(DIR2SYM[dir], end="")
            else:
                print(heat_map[pos], end="")
        print()



def neighbors_of(heat_map, pos):
    neighbors = []
    for dir in NEIGHBOR_DIRECTIONS:
        npos = pos + dir
        # if 0 <= npos.real < rows and 0 <= npos.imag < cols:
        if npos in heat_map:
            neighbors.append((npos, dir))
    return neighbors


def last_3_same_direction(pos, prev, dir):
    pos1, dir1 = prev[pos]
    pos2, dir2 = prev[pos1]
    _pos3, dir3 = prev[pos2]
    return all([d == dir for d in [dir1, dir2, dir3]])

    # tolerance = 1e-9
    # return all([(abs(dir.real - d.real) < tolerance and abs(dir.imag - d.imag) < tolerance) if d else False for d in [dir1, dir2, dir3]])

def dir_count(pos, prev, dir):
    count = 0
    ppos, pdir = prev[pos]
    while pdir == dir:
        count += 1
        ppos, pdir = prev[ppos]
    return count

# Run (constrained) Dijkstra on the directed weighted graph calculated from
# heat_map. Going from cell A to neighbor B in heat_map has the edge weight of
# heat_map[B].
# https://en.wikipedia.org/wiki/Constrained_Shortest_Path_First
def constrained_dijkstra(heat_map, rows, cols, pos_start, pos_end):
    que = PriorityQueue() # TODO make a heapq version for comparison
    dist = defaultdict(lambda: float('inf')) # pos -> dist
    prev = defaultdict(lambda: (None, None)) # pos -> (prev_pos, direction_prev_pos_to_pos)
    visited = set()

    dist[pos_start] = 0 # Heat loss of start pos does not count, thus it matches Dijkstra's setup.
    # for row in range(rows):
    #      for col in range(cols):
    #         pos = complex(row, col)
    #         que.put(PrioritizedItem(dist[pos], (pos, None)))
    for pos in heat_map:
        que.put(PrioritizedItem(dist[pos], (pos, None)))

    while not que.empty():
        prio_item = que.get()
        pos, dir = prio_item.item
        # dist = prio_item.priority
        # dcount = dir_count(pos, prev, dir)
        if pos == pos_end:
            # return dist[pos], None, None # TODO proper early return. Or have separate function for calculating path after.
            break
        if (pos, dir) in visited:
             continue
        visited.add((pos, dir)) # TODO necessary to add with dir, is not just pos enough?

        for pos_neighbor, dir_to_neighbor in neighbors_of(heat_map, pos):
            if last_3_same_direction(pos, prev, dir_to_neighbor): # Constraint. Might not work, as it might prevent finding other paths going though this edge?
                alt_dist = float('inf')
            else:
                alt_dist = dist[pos] + heat_map[pos_neighbor]

            if alt_dist < dist[pos_neighbor]:
                prev[pos_neighbor] = (pos, dir_to_neighbor)
                dist[pos_neighbor] = alt_dist

                # PriorityQueue does not have a decrease_priority(). Thus,
                # insert duplicate with lower distance. Then use a visited set
                # to prevent the original with higher distance from being
                # selected later.
                que.put(PrioritizedItem(alt_dist, (pos_neighbor, dir_to_neighbor))) # TODO really the right direction?

    inv_path = [] # [(pos, dir_taken_to_end_up_at_pos)]
    pos = pos_end
    dir = prev[pos][1]
    while pos:
        inv_path.append((pos, dir))
        pos = prev[pos][0]
        dir = prev[pos][1]
    return dist[pos_end], list(reversed(inv_path)), prev


def main():
    heat_map, rows, cols = read_heat_map()
    pos_lava_pool = 0
    pos_factory = complex(rows - 1, cols - 1)
    # pos_factory = complex(5, 11)
    heat_loss, path, _prev = constrained_dijkstra(heat_map, rows, cols, pos_lava_pool, pos_factory)
    # print_map_path(heat_map, rows, cols, prev)
    print(list(path))
    print_map_path(heat_map, rows, cols, path)
    print(heat_loss)

if __name__ == '__main__':
	main()
