#!/usr/bin/env python3
import fileinput
import random
from collections import defaultdict, deque
from copy import deepcopy
from math import prod

import graphviz

DOT_FILE = "graph.dot"


def read_component_graph():
    # Construct a multi-graph.
    edges = defaultdict(lambda: defaultdict(int))  # {name: {neighbor_name: edge_count}}
    for line in fileinput.input():
        name, *others = line.rstrip("\n").replace(":", "").split()
        for other in others:
            edges[name][other] += 1
            edges[other][name] += 1
    return edges


def is_connected(edges):
    nodes = edges.keys()
    visited = set()
    stack = deque([list(nodes)[0]])

    while stack:
        node = stack.pop()
        if node in visited:
            continue
        visited.add(node)

        for nnode in edges[node]:
            stack.append(nnode)
    return len(visited) == len(nodes)


def visualize(edges):
    dot = graphviz.Graph(comment="Components", strict=True)
    for name in edges:
        dot.node(name)

    for name, neighbors in edges.items():
        for nname in neighbors:
            dot.edge(name, nname)
    with open(DOT_FILE, "w") as file:
        file.write(dot.source)
    print(f"Wrote {DOT_FILE}. Run:")
    print(f"$ dot -Tpdf {DOT_FILE} -o {DOT_FILE.replace(".dot", ".pdf")}")


# Ref: https://en.wikipedia.org/wiki/Minimum_cut
# Ref: https://en.wikipedia.org/wiki/Karger%27s_algorithm
def kargers_algorithm(adjacency_dict):
    adj = deepcopy(adjacency_dict)
    merges = defaultdict(int)

    while len(adj) > 2:
        node_keep = random.choice(list(adj))
        node_remove = random.choice(list(adj[node_keep]))

        merges[node_keep] += 1 + merges[node_remove]
        del merges[node_remove]

        for node_n in adj[node_remove]:
            nbr_edges = adj[node_n][node_remove]
            del adj[node_n][node_remove]

            if node_n != node_keep:
                adj[node_n][node_keep] += nbr_edges
                adj[node_keep][node_n] += nbr_edges

        del adj[node_remove]

    cut = sum(count for edges in adj.values() for count in edges.values()) / 2
    # The node itself is not counted in the merged stats.
    component_sizes = [1 + c for c in merges.values()]
    return cut, component_sizes


def main():
    edges = read_component_graph()

    # assert is_connected(edges)
    # visualize(edges)

    cut = -1
    while cut != 3:
        cut, component_sizes = kargers_algorithm(edges)
    print(prod(component_sizes))


if __name__ == "__main__":
    main()
