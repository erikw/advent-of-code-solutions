#!/usr/bin/env python3
# h/t https://www.reddit.com/r/adventofcode/comments/18evyu9/comment/kcqmhwk/
import fileinput

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
    TILE_START: ((-1, 0), (0, -1), (0, 1), (1, 0)),
    PIPE_NORTH_SOUTH: ((-1, 0), (1, 0)),
    PIPE_WEST_EAST: ((0, -1), (0, 1)),
    PIPE_NORTH_EAST: ((-1, 0), (0, 1)),
    PIPE_NORTH_WEST: ((-1, 0), (0, -1)),
    PIPE_SOUTH_WEST: ((0, -1), (1, 0)),
    PIPE_SOUTH_EAST: ((0, 1), (1, 0)),
}

EXPLORE_DIRECTIONS = {
    TILE_GROUND: None,
    TILE_START: None,
    PIPE_NORTH_SOUTH: ((0, -1), (0, 1)),
    PIPE_WEST_EAST: ((-1, 0), (1, 0)),
    PIPE_NORTH_EAST: ((1, -1), (-1, 1)),
    PIPE_NORTH_WEST: ((-1, -1), (1, 1)),
    PIPE_SOUTH_WEST: ((1, -1), (-1, 1)),
    PIPE_SOUTH_EAST: ((-1, -1), (1, 1)),
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


def neighbors_pipe_of(grid, node):
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


GRID_DIRS = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
]


def neighbors_grid_of(node):
    return [tuple(i + j for i, j in zip(node, d)) for d in GRID_DIRS]


def find_loop(grid, pos_start):
    # DFS
    loop = []
    discovered_nodes = set([pos_start])
    nodes = [pos_start]
    while nodes:
        node = nodes.pop()
        loop.append(node)
        for neighbor in neighbors_pipe_of(grid, node):
            if neighbor not in discovered_nodes:
                discovered_nodes.add(neighbor)
                nodes.append(neighbor)
    return loop


def insert_pipe(grid, pos_start):
    neighbor_steps = []
    for step in NEIGHBOR_DIRECTIONS[tile(grid, pos_start)]:
        neighbor = tuple(i + j for i, j in zip(pos_start, step))
        neighbor_neighbors = [
            tuple(i + j for i, j in zip(neighbor, nn))
            for nn in NEIGHBOR_DIRECTIONS[tile(grid, neighbor)]
        ]
        if (
            tile(grid, neighbor) not in (TILE_GROUND, TILE_START)
            and pos_start in neighbor_neighbors
        ):
            neighbor_steps.append(step)

    pipe_from_neighbor_steps = {v: k for k, v in NEIGHBOR_DIRECTIONS.items()}

    grid[pos_start[0]] = grid[pos_start[0]].replace(
        TILE_START, pipe_from_neighbor_steps[tuple(sorted(neighbor_steps))]
    )


def polygon_area(loop):
    pairs = tuple(zip(loop, loop[1:] + [loop[0]]))
    return int(abs(sum(0.5 * (n1[1] + n2[1]) * (n1[0] - n2[0]) for n1, n2 in pairs)))


def enclosed_nodes(loop):
    """
    With Pick's Theorem (https://en.wikipedia.org/wiki/Pick%27s_theorem), the area of an integral polygon is
    A = i + b/2 - 1, i = nbr interior points, b = nbr exterior (loop) points.
    We want to calculate i = A - b/2 + 1
    A for a polygon area can be calculated with the shoelace formula (https://en.wikipedia.org/wiki/Shoelace_formula).
    """
    area = polygon_area(loop)
    interior_points = area - len(loop) / 2 + 1
    return int(interior_points)


def main():
    grid, pos_start = read_input()
    main_loop = find_loop(grid, pos_start)

    # insert_pipe(grid, pos_start) # Not needed actually

    print(enclosed_nodes(main_loop))


if __name__ == "__main__":
    main()
