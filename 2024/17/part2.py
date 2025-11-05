#!/usr/bin/env python3
# h/t https://www.reddit.com/r/adventofcode/comments/1hg38ah/comment/m2gizvj/
import fileinput

import z3


def read_input():
    in_reg, in_instr = "".join(fileinput.input()).split("\n\n")
    registers = [int(line.split(":")[1]) for line in in_reg.splitlines()]
    instructions = list(map(int, in_instr.split()[1].split(",")))
    return registers, instructions


def main():
    instructions = read_input()[1]

    optimizer = z3.Optimize()
    za = z3.BitVec("a", 64)

    # See manually decoded program in decoded.rb
    a, b, c = za, 0, 0
    for instruction in instructions:
        b = a % 8
        b ^= 7
        # Right shift is more z3-friendly, same as dividing with 2**b for uint.
        c = z3.LShR(a, b)
        b = b ^ 7
        b = b ^ c
        a = z3.LShR(a, 3)
        optimizer.add((b % 8) == instruction)
    optimizer.add(a == 0)  # Assert program terminates.

    optimizer.minimize(za)
    if optimizer.check() == z3.sat:
        reg_a = optimizer.model()[za]
        print(reg_a)
    else:
        print("No solution.")


if __name__ == "__main__":
    main()
