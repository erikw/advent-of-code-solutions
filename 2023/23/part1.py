#!/usr/bin/env python3
# The graph seems to be DAG.
import fileinput
from copy import deepcopy

import sys
sys.setrecursionlimit(3500)


SYM_PATH = "."
SYM_FOREST = "#"
SYM_START = "S"

DIRECTION_DELTAS = [
     ("^", -1, 0),
     ("v", 1, 0),
     ("<", 0, -1),
     (">", 0, 1),
]

def read_map():
    map  = [l.rstrip("\n") for l in fileinput.input()]
    return map, (0, 1), (len(map) - 1, len(map[0]) - 2)

def print_map(map, pos_start):
     for row in range(len(map)):
        line = []
        for col in range(len(map[0])):
            if (row, col) == pos_start:
                line.append(SYM_START)
            else:
                 line.append(map[row][col])
        print("".join(line))


def can_visit(map, pos, dir):
    row, col = pos
    return 0 <= row < len(map) and 0 <= col < len(map[0]) and map[row][col] in [SYM_PATH, dir]


# Recursive DFS brute-force
def longest_path(map, pos_end, pos, visited=set()):
    if pos == pos_end:
         return 0

    paths = [float('-inf')]
    for dir, dr, dc in DIRECTION_DELTAS:
        npos = pos[0] + dr, pos[1] + dc
        if npos not in visited and can_visit(map, npos, dir):
            visited.add(npos)
            paths.append(1 + longest_path(map, pos_end, npos, visited))
            visited.remove(npos)
    return max(paths)



def main():
    map, pos_start, pos_end = read_map()
    # print_map(map, pos_start)

    longest = longest_path(map, pos_end, pos_start)
    print(longest)

if __name__ == '__main__':
	main()
