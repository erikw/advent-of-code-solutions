#!/usr/bin/env python3
import fileinput


def first_digit(line):
    for chr in line:
        if chr.isdigit():
            return chr
    return None


def calibration_value(line):
    first = first_digit(line)
    last = first_digit(reversed(line))
    return int(first + last)


def main():
    sum = 0
    for line in fileinput.input():
        line = line.rstrip("\n")
        sum += calibration_value(line)
    print(sum)


if __name__ == "__main__":
    main()
