#!/usr/bin/env python3
import fileinput
from pprint import pprint
from collections import deque

# STEPS = 1
# STEPS = 6
STEPS = 64

SYM_START = "S"
SYM_PLOT = "."
SYM_ROCK = "#"

NEIGHBOR_DELTAS = [
     (-1, 0),
     (1, 0),
     (0, -1),
     (0, 1),
]

def read_map():
    map = []
    pos_start = None
    for i, line in enumerate(fileinput.input()):
        row = list(line.rstrip("\n"))
        try:
            col_start = row.index(SYM_START)
        except ValueError:
            pass
        else:
             row[col_start] = SYM_PLOT
             pos_start = (i, col_start)
        map.append(row)
    return map, pos_start

def print_map(map):
     for row in map:
          print("".join(row))

def positions_steps_away(map, pos_start, steps_target):
    que = deque([(*pos_start, 0)])
    visited = set()
    pos_targets = set()

    while que:
        elem = que.popleft()
        if elem in visited:
            continue
        visited.add(elem)
        row, col, steps = elem

        if steps == steps_target:
            pos_targets.add((row, col))
            continue

        for dr, dc in NEIGHBOR_DELTAS:
            nrow, ncol = row + dr, col + dc
            if not (0 <= nrow < len(map) and 0 <= ncol < len(map[0]) and map[nrow][ncol] == SYM_PLOT):
                continue
            que.append((nrow, ncol, steps + 1))

    return len(pos_targets)




def main():
    map, pos_start = read_map()
    garden_positions = positions_steps_away(map, pos_start, STEPS)
    print(garden_positions)

if __name__ == '__main__':
	main()
