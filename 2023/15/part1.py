#!/usr/bin/env python3
import fileinput


def read_init_seq():
    return list(fileinput.input())[0].rstrip("\n").split(",")


def hash(step):
    value = 0
    for char in step:
        value += ord(char)
        value *= 17
        value %= 256
    return value


def main():
    init_seq = read_init_seq()
    print(sum(map(hash, init_seq)))


if __name__ == "__main__":
    main()
