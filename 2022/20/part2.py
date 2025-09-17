#!/usr/bin/env python3
import fileinput

NTH_NUMBERS = [1000, 2000, 3000]
DECRYPTION_KEY = 811589153
MIXINGS = 10


class Node:
    def __init__(self, id, value):
        self._id = id
        self._value = value
        self._next = None
        self._prev = None

    def __str__(self):
        rep = f"Node(id={self._id}, value={self._value}"

        if self._prev:
            rep += f", prevID={self._prev._id}"
        else:
            rep += ", prev=None"

        if self._next:
            rep += f", nextID={self._next._id}"
        else:
            rep += ", next=None"

        return rep + ")"

    __repr__ = __str__

    @property
    def value(self):
        return self._value

    @property
    def next(self):
        return self._next

    @next.setter
    def next(self, node):
        if not (node is None or isinstance(node, Node)):
            raise ValueError("Not a node.")
        self._next = node

    @property
    def prev(self):
        return self._prev

    @prev.setter
    def prev(self, node):
        if not (node is None or isinstance(node, Node)):
            raise ValueError("Not a node.")
        self._prev = node


def read_enc_file():
    return list(map(int, fileinput.input()))


def print_nodes(nodes):
    start = nodes[0]
    cur = nodes[0]
    chain = ""
    while True:
        chain += f"({cur.value: >2})"
        cur = cur.next
        if cur == start:
            break
    print(chain)


def mix(nodes):
    for node in nodes:
        if node.value == 0:
            continue

        prev, next = node.prev, node.next

        # Remove current node.
        node.prev.next = node.next
        node.next.prev = node.prev
        node.prev = None
        node.next = None

        # Advanced to insertion point
        steps = node.value % (len(nodes) - 1)
        for _ in range(steps):
            prev = prev.next
            next = next.next

        # Insert node at insertion point.
        prev.next = node
        next.prev = node
        node.prev = prev
        node.next = next


def nth_number(nodes, node0, nth):
    steps = nth % len(nodes)
    node_nth = node0
    for _ in range(steps):
        node_nth = node_nth.next
    return node_nth.value


def main():
    numbers = read_enc_file()
    nodes = [None] * len(numbers)
    node0 = None
    for i, n in enumerate(numbers):
        nodes[i] = Node(i, n * DECRYPTION_KEY)
        if n == 0:
            node0 = nodes[i]

    for i in range(len(nodes)):
        i_next = (i + 1) % len(nodes)
        i_prev = (i - 1) % len(nodes)
        nodes[i].prev = nodes[i_prev]
        nodes[i].next = nodes[i_next]

    for _ in range(MIXINGS):
        mix(nodes)

    num_sum = 0
    for nth in NTH_NUMBERS:
        num_sum += nth_number(nodes, node0, nth)

    print(num_sum)


if __name__ == "__main__":
    main()
