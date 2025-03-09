#!/usr/bin/env python3
# NOPE too CPU-intensive.

import fileinput
import re
from itertools import cycle

NODE_CHAR_START = "A"
NODE_CHAR_END = "Z"


def read_input():
    with fileinput.input() as file:
        instructions = [int(i) for i in file.readline().rstrip("\n").replace("L", "0").replace("R", "1")]
        file.readline()

        network = {}
        nodes_start = set()
        nodes_end = set()
        while line := file.readline():
            n1, n2, n3 = re.findall(r"[A-Z1-9]{3}", line)
            network[n1] = (n2, n3)
            if n1.endswith(NODE_CHAR_START):
                nodes_start.add(n1)
            if n1.endswith(NODE_CHAR_END):
                nodes_end.add(n1)
    return (instructions, network, nodes_start, nodes_end)


def main():
    instructions, network, nodes_start, nodes_end = read_input()

    node_cycles = []
    for node in nodes_start:
        ic = cycle(instructions)
        steps = 0
        while node not in nodes_end:
            dir = next(ic)
            node = network[node][dir]
            steps += 1
        node_cycles.append(steps)

    longest_cycle = max(node_cycles)
    found = False
    repeats = 0
    while not found:
        repeats += 1
        steps = longest_cycle * repeats
        if all((steps % nc == 0) for nc in node_cycles):
            found = True
    print(repeats * longest_cycle)


if __name__ == "__main__":
    main()
