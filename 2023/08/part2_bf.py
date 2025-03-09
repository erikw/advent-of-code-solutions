#!/usr/bin/env python3
# NOPE too CPU-intensive.

import fileinput
import re
from itertools import cycle
from pprint import pprint

NODE_CHAR_START = "A"
NODE_CHAR_END = "Z"


def read_input():
    with fileinput.input() as file:
        instructions = [
            int(i)
            for i in file.readline().rstrip("\n").replace("L", "0").replace("R", "1")
        ]
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
    pprint(network)
    pprint(nodes_start)
    pprint(nodes_end)

    instructions = cycle(instructions)
    nodes = nodes_start.copy()
    steps = 0
    history = set()
    history.add("".join(sorted(list(nodes))))
    while nodes != nodes_end:
        # print(f"At Step: {steps + 1}", end="")
        # pprint(nodes)
        dir = next(instructions)
        nodes_next = set()
        for node in nodes:
            nodes_next.add(network[node][dir])
        nodes = nodes_next
        if "".join(sorted(list(nodes_next))) in history:
            print("History is repeating itself")
        history.add("".join(sorted(list(nodes_next))))
        steps += 1
    print(steps)


if __name__ == "__main__":
    main()
