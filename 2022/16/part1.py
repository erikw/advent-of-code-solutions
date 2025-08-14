#!/usr/bin/env python3
import functools
import re
import sys
from typing import DefaultDict

from python_mermaid.diagram import Link, MermaidDiagram, Node

TOTAL_MIN = 30
VALVE_START = "AA"
VALVE_PATTERN = re.compile(
    r"Valve (?P<name>[A-Z]{2}) has flow rate=(?P<flow>\d+); tunnels? leads? to valves? (?P<neighbors>.+)"
)


def read_network():
    nodes = set()
    edges = []
    flow = {}
    for node, flow_str, neighbors in VALVE_PATTERN.findall(open(sys.argv[1]).read()):
        nodes.add(node)
        for neighbor in neighbors.split(", "):
            edges.append((node, neighbor))
        if flow_str != "0":  # Remove as possible destination.
            flow[node] = int(flow_str)
    return nodes, edges, flow


# Ref: https://en.wikipedia.org/wiki/Floyd–Warshall_algorithm
def floyd_warshall_pairwise_shortes_paths(nodes, edges, weights):
    n = len(nodes)
    dist = DefaultDict(lambda: float("inf"))

    for u, v in edges:
        dist[u, v] = weights[u, v]

    for n in nodes:
        dist[n, n] = 0

    for k in nodes:
        for i in nodes:
            for j in nodes:
                alt = dist[i, k] + dist[k, j]
                dist[i, j] = min(dist[i, j], alt)

    return dist


def mermaid_diagram(vertices, edges):
    nodes = {v: Node(v) for v in vertices}
    links = [Link(nodes[u], nodes[v]) for u, v in edges]
    chart = MermaidDiagram(title="Network", nodes=nodes.values(), links=links)
    print(chart)  # Paste output at https://mermaid.live/


def main():
    nodes, edges, flow = read_network()

    # mermaid_diagram(nodes, edges)

    weights = DefaultDict(lambda: 1)
    dist = floyd_warshall_pairwise_shortes_paths(nodes, edges, weights)

    # h/t https://www.reddit.com/r/adventofcode/comments/zn6k1l/comment/j0fti6c/
    @functools.cache
    def max_pressure(time, node_cur, nodes_unvisited):
        pressures = [0]
        for node_other in nodes_unvisited:
            node_dist = dist[node_cur, node_other]
            if node_dist < time:
                time_left = time - node_dist - 1
                pressure = flow[node_other] * time_left
                pressure += max_pressure(
                    time_left, node_other, nodes_unvisited - {node_other}
                )
                pressures.append(pressure)

        return max(pressures)

    pressure = max_pressure(
        TOTAL_MIN, VALVE_START, frozenset(flow.keys() - {VALVE_START})
    )
    print(pressure)


if __name__ == "__main__":
    main()
