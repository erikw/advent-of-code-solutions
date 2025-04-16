#!/usr/bin/env python3
import sys

ROW_MULTIPLIER = 100

CELL_ASH = "."
CELL_ROCKS = "#"


def read_patterns():
    return [
        [list(r) for r in p.split("\n")]
        for p in open(sys.argv[1]).read().rstrip().split("\n\n")
    ]


def smudge(cell):
    return CELL_ROCKS if cell == CELL_ASH else CELL_ASH


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


def reflection_rows(pattern, col_version=False):
    rows_above = rows_above_reflection(pattern)
    rows_below = rows_above_reflection(reversed(pattern))
    if rows_below:
        rows_below = len(pattern) - rows_below

    # By multiplying with ROW_MULTIPLIER already, we can put both row and column result in the same set in the caller, simplifying the logic, as they won't class after multiplication.
    return set(
        r * ROW_MULTIPLIER if not col_version else r
        for r in (rows_above, rows_below)
        if r
    )


def pattern_summary(pattern):
    reflects_orig = reflection_rows(pattern)

    pattern_t = list(zip(*pattern))  # Transpose
    reflects_orig.update(reflection_rows(pattern_t, col_version=True))

    for i in range(len(pattern)):
        for j in range(len(pattern[0])):
            pattern[i][j] = smudge(pattern[i][j])
            reflects_smudged = reflection_rows(pattern)
            pattern_t = list(zip(*pattern))  # Transpose
            reflects_smudged.update(reflection_rows(pattern_t, col_version=True))
            pattern[i][j] = smudge(pattern[i][j])

            reflects_new = reflects_smudged - reflects_orig
            if reflects_new:
                return list(reflects_new)[0]
    return list(reflects_orig)[0]


def main():
    patterns = read_patterns()
    print(sum(map(pattern_summary, patterns)))


if __name__ == "__main__":
    main()
