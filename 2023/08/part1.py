#!/usr/bin/env python3
import fileinput
import re
from itertools import cycle

NODE_START = "AAA"
NODE_END = "ZZZ"


def read_input():
    with fileinput.input() as file:
        instructions = [
            int(i)
            for i in file.readline().rstrip("\n").replace("L", "0").replace("R", "1")
        ]
        file.readline()

        network = {}
        while line := file.readline():
            nodes = re.findall(r"[A-Z]{3}", line)
            network[nodes[0]] = nodes[1:]
    return (instructions, network)


def main():
    instructions, network = read_input()

    instructions = cycle(instructions)
    node = NODE_START
    steps = 0
    while node != NODE_END:
        dir = next(instructions)
        node = network[node][dir]
        steps += 1
    print(steps)


if __name__ == "__main__":
    main()
