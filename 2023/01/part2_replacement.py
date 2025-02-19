#!/usr/bin/env python3
import fileinput

# h/t https://www.reddit.com/r/adventofcode/comments/1883ibu/comment/kbielt0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
TEXT_DIGITS = {
    "one": "one1one",
    "two": "two2two",
    "three": "three3three",
    "four": "four4four",
    "five": "five5five",
    "six": "six6six",
    "seven": "seven7seven",
    "eight": "eight8eight",
    "nine": "nine9nine",
}


def first_digit(line):
    for chr in line:
        if chr.isdigit():
            return chr
    return None


def calibration_value(line):
    first = first_digit(line)
    last = first_digit(reversed(line))
    return int(first + last)


def text2digit(line):
    for text, digit in TEXT_DIGITS.items():
        line = line.replace(text, digit)
    return line


# def main():
#     sum = 0
#     for line in fileinput.input():
#         sum += calibration_value(text2digit(line))
#     print(sum)


def main():
    print(sum(map(lambda l: calibration_value(text2digit(l)), fileinput.input())))


if __name__ == "__main__":
    main()
