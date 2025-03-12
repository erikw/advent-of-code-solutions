#!/usr/bin/env python3
import fileinput
from pprint import pprint

PIPE_NORTH_SOUTH = "|"
PIPE_WEST_EAST = "-"
PIPE_NORTH_EAST = "L"
PIPE_NORTH_WEST = "J"
PIPE_SOUTH_WEST = "7"
PIPE_SOUTH_EAST = "F"
TILE_GROUND = "."
TILE_START = "S"

NEIGHBOR_DIRECTIONS = {
    TILE_GROUND: (),
    TILE_START: ((-1, 0), (0, 1), (1, 0), (0, -1)),
    PIPE_NORTH_SOUTH: ((-1, 0), (1, 0)),
    PIPE_WEST_EAST: ((0, -1), (0, 1)),
    PIPE_NORTH_EAST: ((-1, 0), (0, 1)),
    PIPE_NORTH_WEST: ((-1, 0), (0, -1)),
    PIPE_SOUTH_WEST: ((1, 0), (0, -1)),
    PIPE_SOUTH_EAST: ((1, 0), (0, 1)),
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


def tile(grid, node_pos):
    row, col = node_pos
    if -1 in [row, col] or row == len(grid) or col == len(grid[0]):
        return TILE_GROUND
    else:
        return grid[row][col]


def neighbors_of(grid, node):
    valid_neighbors = []
    for step in NEIGHBOR_DIRECTIONS[tile(grid, node)]:
        neighbor = tuple(i + j for i, j in zip(node, step))
        neighbor_neighbors = [
            tuple(i + j for i, j in zip(neighbor, nn))
            for nn in NEIGHBOR_DIRECTIONS[tile(grid, neighbor)]
        ]
        if (
            tile(grid, neighbor) not in (TILE_GROUND, TILE_START)
            and node in neighbor_neighbors
        ):
            valid_neighbors.append(neighbor)

    return valid_neighbors


def furthest_distance(grid, pos_start):
    # BFS
    discovered_nodes = set()
    nodes = [pos_start]
    depth = -1
    while nodes:
        depth += 1
        nodes_next = []
        for node in nodes:
            for neighbor in neighbors_of(grid, node):
                if neighbor not in discovered_nodes:
                    discovered_nodes.add(neighbor)
                    nodes_next.append(neighbor)
        nodes = nodes_next
    return depth


def main():
    grid, pos_start = read_input()
    # print_grid(grid)
    dist = furthest_distance(grid, pos_start)
    print(dist)


if __name__ == "__main__":
    main()
