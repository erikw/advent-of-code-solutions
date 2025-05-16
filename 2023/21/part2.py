#!/usr/bin/env python3
import fileinput
from collections import deque
from math import ceil
import numpy as np

STEPS = 26501365

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


# Expand map to cover the max number steps in one straight line from the start position (assuming start position in the middle of the grid).
def expand_map(map, pos_start, max_steps):
    times = ceil(max_steps / (len(map)/2)) 
    mape = []
    for _ in range(times):
        for row in map:
            mape.append(times * row)
    return mape, (pos_start[0] + len(map) * (times//2), pos_start[1] + len(map[0]) * (times//2))

def main():
    map, pos_start = read_map()

    # h/t https://www.reddit.com/r/adventofcode/comments/18nevo3/comment/keao6r4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    # As STEPS = 202300 * len(map) + 65
    # or: 26501365 = 202300 * 131 + 65
    n = STEPS // len(map) # 202300
    r = STEPS % len(map) # 65
    # it suggests a recurrence on period 131 * n + 65

    # As of the visual shape of the input data, it looks like we could fit a quadratic function to it y = ax^2 + bx + c
    # To fit a function, we can solve with linear matrix equations with  A * x = b <=> x = A^-1 * b where A is coefficient matrix.

    # First get some data points for x=[0, 1, 2]
    ans = []
    for x in range(3):
        steps = x * len(map) + r
        mape, pos_starte = expand_map(map, pos_start, steps)
        ans.append(positions_steps_away(mape, pos_starte, steps))
    b = np.array(ans)

    # A is the Vandermonde matrix with each row the geometric progression (regression?) [x^2 x^1 x^0] for x:s (0, 1, 2) (same x's used to calculate y1, y2, y3 above)
    # The vandermonde matrix usually goes in the other direction with each row [x^0 x^1 x^2]. Having it reverse just makes the solution vector x's elements appear in the same order we want to use it.
    # See 'polynomial interpolation' at https://en.wikipedia.org/wiki/Vandermonde_matrix#Applications
    # [ 0^2 0^1 0^0 ]   [ 0 0 1 ]
    # [ 1^2 1^1 1^0 ] = [ 1 1 1 ]
    # [ 2^2 2^1 2^0 ]   [ 4 2 1 ]
    A = np.matrix([[0, 0, 1], [1, 1, 1], [4, 2, 1]])

    # Solve for solution vector x!
    x = np.linalg.solve(A, b).astype(np.int64)

    # Now we have found the coefficients for the quadratic function, namely x.
    # Thus we can calculate the number of garden_positions for the give period n we want (according to earlier reasoning)
    garden_positions = x[0] * n**2 + x[1] * n + x[2]
    print(garden_positions)

if __name__ == '__main__':
	main()
