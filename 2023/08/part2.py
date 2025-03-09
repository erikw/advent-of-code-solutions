#!/usr/bin/env python3

import fileinput
import re
from itertools import cycle
import math

NODE_CHAR_START = "A"
NODE_CHAR_END = "Z"


# Ref: https://stackoverflow.com/a/42472824/265508
# Turns out there is math.lcm....
def lcm(*args):
    lcm = 1
    for arg in args:
        lcm = lcm * arg // math.gcd(lcm, arg)
    return lcm


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

    # cycles = lcm(*node_cycles)
    cycles = math.lcm(*node_cycles)
    print(cycles)


if __name__ == "__main__":
    main()
