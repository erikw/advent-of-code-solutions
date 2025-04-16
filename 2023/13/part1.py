#!/usr/bin/env python3
import sys

ROW_MULTIPLIER = 100


def read_patterns():
    return [p.split("\n") for p in open(sys.argv[1]).read().rstrip().split("\n\n")]


def rows_above_reflection(pattern):
    stack = []
    popped = 0
    for row in pattern:
        if stack and row == stack[-1]:
            stack.pop()
            popped += 1
            if not stack:
                break
        else:
            stack.append(row)

    return None if stack else popped


def reflection_rows(pattern):
    rows_above = rows_above_reflection(pattern)
    if not rows_above:  # Then reverse-try-again
        rows_below = rows_above_reflection(reversed(pattern))
        if rows_below:
            rows_above = len(pattern) - rows_below
    return rows_above


def pattern_summary(pattern):
    reflect_rows = reflection_rows(pattern)
    if reflect_rows:
        return reflect_rows * ROW_MULTIPLIER

    pattern_t = list(zip(*pattern))  # Transpose
    reflect_cols = reflection_rows(pattern_t)
    return reflect_cols


def main():
    patterns = read_patterns()
    print(sum(map(pattern_summary, patterns)))


if __name__ == "__main__":
    main()
