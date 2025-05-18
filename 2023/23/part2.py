#!/usr/bin/env python3
# Allowing any direction of the slopes seems to make this an undirected cyclic graph meaning it's NP-hard to find a longest path. Ref: https://en.wikipedia.org/wiki/Longest_path_problem
# Solution: compress the graph by connecting single-direction paths so that the problem space becomes brut-force'able!
import fileinput
from collections import defaultdict, deque

SYM_PATH = "."
SYM_FOREST = "#"
SYM_START = "S"

DIRECTION_DELTAS = [
     ("^", -1, 0),
     ("v", 1, 0),
     ("<", 0, -1),
     (">", 0, 1),
]

DIR_OPPOSITE = {
    "^": "v",
    "v": "^",
    "<": ">",
    ">": "<",
}

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
    sym_visitable = [SYM_PATH, dir, DIR_OPPOSITE[dir]]
    return 0 <= row < len(map) and 0 <= col < len(map[0]) and map[row][col] in sym_visitable


def neighbors_of(map, pos):
    nposs = set()
    for dir, dr, dc in DIRECTION_DELTAS:
        npos = pos[0] + dr, pos[1] + dc
        if can_visit(map, npos, dir):
            nposs.add(npos)
    return nposs


def construct_edges(map, pos_start, pos_end):
    edges = defaultdict(set) # pos -> [(npos, len)]
    stack = deque([pos_start]) # (pos, pos_prev)
    visited = set()

    while stack:
        pos = stack.pop()
        if pos in visited:
            continue
        visited.add(pos)

        for npos in neighbors_of(map, pos):
            edges[pos].add((npos, 1))
            edges[npos].add((pos, 1))
            stack.append(npos)
    return edges



def compact_edges(edges):
    positions = list(edges.keys())
    for pos in positions:
        if pos not in edges:
            continue

        pos_edges = edges[pos]
        if len(pos_edges) != 2:
            continue

        (npos1, len1), (npos2, len2) = pos_edges
        edges[npos1].remove((pos, len1))
        edges[npos2].remove((pos, len2))
        edges[npos1].add((npos2, len1 + len2))
        edges[npos2].add((npos1, len1 + len2))
        del edges[pos]


def compress_graph(map, pos_start, pos_end):
    edges = construct_edges(map, pos_start, pos_end)
    compact_edges(edges)
    return edges


# Recursive DFS brute-force on compressed graph.
def longest_path(edges, pos_end, pos, visited=set()):
    if pos == pos_end:
        return 0

    paths = [float('-inf')]
    for npos, length in edges[pos]:
        if npos not in visited:
            visited.add(npos)
            paths.append(length + longest_path(edges, pos_end, npos, visited))
            visited.remove(npos)
    return max(paths)

# DFS brute-force on compressed graph.
# How to do with a stack: add a "undo" node to the stack that removes the
# current not from visited set when we're done exploring the subpath,
# so that this node can be found by another path. h/t # https://www.reddit.com/r/adventofcode/comments/18oy4pc/comment/kekhj7f/
def longest_path_stack(edges, pos_start, pos_end):
    end_dists = []
    stack = deque([(pos_start, 0)]) # (pos, dist)
    visited = set() # pos

    while stack:
        pos, dist = stack.pop()

        if dist is None: # The undo-visited position enables us to explore a path involving this position again.
            visited.remove(pos)
            continue

        if pos == pos_end:
            end_dists.append(dist)
            continue

        if pos in visited:
            continue

        visited.add(pos)
        stack.append((pos, None)) # Add undo- node to stack.

        for npos, ndist in edges[pos]:
            stack.append((npos, dist + ndist))
    return max(end_dists)



def main():
    map, pos_start, pos_end = read_map()
    edges = compress_graph(map, pos_start, pos_end)

    longest = longest_path(edges, pos_end, pos_start)
    # longest = longest_path_stack(edges, pos_end, pos_start)
    print(longest)


if __name__ == '__main__':
	main()
