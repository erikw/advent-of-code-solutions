#!/usr/bin/env python3
import fileinput

TEXT_DIGITS = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}


def first_digit(line):
    for chr in line:
        if chr.isdigit():
            return chr
    return None


def text2digit_first(line):
    for i in range(len(line)):
        for text, digit in TEXT_DIGITS.items():
            if line[i:].startswith(text):
                return line[:i] + digit + line[i + len(text) :]
    return line


def text2digit_last(line):
    for i in range(len(line), 0, -1):
        for text, digit in TEXT_DIGITS.items():
            if line[i:].startswith(text):
                return line[:i] + digit + line[i + len(text) :]
    return line


def calibration_value(line):
    first = first_digit(text2digit_first(line))
    last = first_digit(reversed(text2digit_last(line)))
    return int(first + last)


def main():
    sum = 0
    for line in fileinput.input():
        sum += calibration_value(line)
    print(sum)


if __name__ == "__main__":
    main()
