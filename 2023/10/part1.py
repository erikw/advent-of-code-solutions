#!/usr/bin/env python3
import fileinput
from pprint import pprint
from collections import deque

PIPE_NORTH_SOUTH = "|"
PIPE_WEST_EAST = "-"
PIPE_NORTH_EAST = "L"
PIPE_NORTH_WEST = "J"
PIPE_SOUTH_WEST = "7"
PIPE_SOUTH_EAST = "F"
TILE_GROUND = "."
TILE_START = "S"

NEIGHBOR_DIRECTIONS = {
    PIPE_NORTH_SOUTH: ((-1, 0), (1, 0)),
    PIPE_WEST_EAST: ((0, -1), (0, 1)),
    PIPE_NORTH_EAST: ((-1, 0), (0, 1)),
    PIPE_NORTH_WEST: ((-1, 0), (0, -1)),
    PIPE_SOUTH_WEST: ((1, 0), (0, -1)),
    PIPE_SOUTH_EAST: ((1, 0), (0, 1)),
    TILE_GROUND: (),
    TILE_START: ()
}

def read_input():
    grid = []
    start = None
    for row, line in enumerate(fileinput.input()):
        grid.append(line.rstrip("\n"))
        col = grid[-1].find(TILE_START)
        if col != -1:
            start = (row, col)
    return (grid, start)

def print_grid(grid):
    print("  " + "".join(str(i) for i in range(len(grid[0]))))
    for row_n, row in enumerate(grid):
         print(f"{row_n} {row}")


def neighbors_of(grid, node):
    neighbors = []
    for step in NEIGHBOR_DIRECTIONS[grid[node]]:
        neighbor = (i+j for i, j in zip(node, step))
        if grid[neighbor] not IN [TILE_GROUND, TILE_START] # TODO need to check direction of current pipe and direction of the neighbour pipe too. Can also put in constant dictionary, which pipes goes with what other pipe?




def furthest_distance(grid, pos_start):
    # BFS
    discovered_nodes = set()
    nodes_que = deque([pos_start])
    depth = 0
    while nodes_que:
        depth += 1
        nodes = nodes_que.popleft()
        for node in nodes:
            neighbors = neighbors_of(grid, node)
            for neighbor in neighbors:
                if neighbor not in discovered_nodes:
                    nodes_que.append(neighbor)
            discovered_nodes.update(*neighbors)
    return depth


def main():
    grid, pos_start = read_input()

    print_grid(grid)
    pprint(pos_start)

    dist = furthest_distance(grid, pos_start)
    print(dist)

if __name__ == '__main__':
	main()
