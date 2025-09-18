#!/usr/bin/env python3
import fileinput

from python_mermaid.diagram import Link, MermaidDiagram, Node

MONKEY_ROOT = "root"


def read_monkies():
    monkies = {}
    for line in fileinput.input():
        parts = line.rstrip("\n").split(" ")
        monkey = parts[0][:-1]
        if len(parts) == 2:
            monkies[monkey] = [int(parts[1])]
        else:
            monkies[monkey] = parts[1:]
    return monkies


def mermaid_diagram(monkies):
    nodes = {}
    for monkey, task in monkies.items():
        desc = str(task[0]) if len(task) == 1 else task[1]
        nodes[monkey] = Node(monkey, f"{monkey}[{desc}]")

    links = []
    for monkey, task in monkies.items():
        if len(task) > 1:
            links.append(Link(nodes[monkey], nodes[task[0]]))
            links.append(Link(nodes[monkey], nodes[task[2]]))

    diagram = MermaidDiagram(
        title="Monkey Math", nodes=list(nodes.values()), links=links
    )
    # len(links)> 500, thus https://mermaid.live/ won't accept it.
    with open("diagram.mmd", "w") as f:
        f.write(str(diagram))
    print("Render with mermaid-cli:")
    print("$ mmdc -c ../../.mmdcrc -i diagram.mmd -o diagram.svg")


def compute(lhs, op, rhs):
    match op:
        case "+":
            return lhs + rhs
        case "-":
            return lhs - rhs
        case "*":
            return lhs * rhs
        case "/":
            return lhs / rhs
        case _:
            raise (f"Unknown operator {op}")


# Post-order tree traversal.
def value_of(monkies, monkey):
    task = monkies[monkey]
    if len(task) == 1:
        return task[0]
    else:
        lhs = value_of(monkies, task[0])
        rhs = value_of(monkies, task[2])
        return compute(lhs, task[1], rhs)


def main():
    monkies = read_monkies()

    # By manual inspection, the input looks like a binary tree.
    # mermaid_diagram(monkies)

    value = int(value_of(monkies, MONKEY_ROOT))
    print(value)


if __name__ == "__main__":
    main()
