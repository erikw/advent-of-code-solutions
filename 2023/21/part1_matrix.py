#!/usr/bin/env python3
import fileinput
from pprint import pprint
import scipy.sparse as sparse

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

def adjacency_matrix(map):
    num_poss = len(map) * len(map[0])
    # adj = sparse.csr_matrix((num_poss, num_poss))
    adj = sparse.dok_matrix((num_poss, num_poss))
    for row in range(len(map)):
        for col in range(len(map[0])):
            if map[row][col] != SYM_PLOT:
                continue
            for dr, dc in NEIGHBOR_DELTAS:
                nrow, ncol = row + dr, col + dc
                if 0 <= nrow < len(map) and 0 <= ncol < len(map[0]) and map[nrow][ncol] == SYM_PLOT:
                   adj_idx =  row * len(map[0]) + col
                   adj_nidx = nrow * len(map[0]) + ncol
                   adj[adj_idx, adj_nidx] = 1
                   adj[adj_nidx, adj_idx] = 1
    return adj




def main():
    map, pos_start = read_map()

    # With an adjacency matrix A and then A^k:
    # cell (x,y) in A^k means the number of ways we can end up in y starting form x with k steps.
    # Thus we are looking for sum(A^k[start_plot]), meaning the sum of all positions we can end up at after k steps starting from the start plot.
    # Ref: https://math.stackexchange.com/a/207835/147723

    map_adjm = adjacency_matrix(map)
    map_adjm_pow = sparse.linalg.matrix_power(map_adjm, STEPS)
    adj_start_idx = pos_start[0] * len(map[0]) + pos_start[1]

    garden_positions = map_adjm_pow.count_nonzero(axis=1)[adj_start_idx]
    print(garden_positions)

if __name__ == '__main__':
	main()
