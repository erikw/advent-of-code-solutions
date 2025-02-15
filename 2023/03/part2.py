#!/usr/bin/env python3
import fileinput
from collections import defaultdict
from math import prod

SYM_EMPTY = "."
SYM_GEAR = "*"


def print_schema(schema):
    for row in schema:
        print(row)


def is_gear(schema, row, col):
    return schema[row][col] == SYM_GEAR


def get_part_number(schema, row, col):
    if not schema[row][col].isdigit():
        return [None, None]

    nbr_len = 1
    while schema[row][col + nbr_len].isdigit():
        nbr_len += 1

    # NOTE we could make this more efficient by not checking the found number [row, row+nbr_len]...
    for adj_row in range(row - 1, row + 2):
        for adj_col in range(col - 1, col + nbr_len + 1):
            adj = schema[adj_row][adj_col]
            if is_gear(schema, adj_row, adj_col):
                return [schema[row][col : col + nbr_len], (adj_row, adj_col)]
    return [None, None]


def find_gear_ratios(schema):
    row_start = 1
    row_len = len(schema) - 1
    col_start = 1
    col_len = len(schema[0]) - 1

    gear2partnbrs = defaultdict(list)
    row = row_start
    while row < row_len:
        col = col_start
        while col < col_len:
            part_nbr_s, gear_pos = get_part_number(schema, row, col)
            if part_nbr_s:
                col += len(part_nbr_s)
                gear2partnbrs[gear_pos].append(int(part_nbr_s))
            else:
                col += 1
        row += 1

    gear_ratios = [prod(v) for v in gear2partnbrs.values() if len(v) == 2]
    return gear_ratios


def main():
    schema = []
    for row in fileinput.input():
        schema.append(SYM_EMPTY + row.rstrip("\n") + SYM_EMPTY)
    padding = SYM_EMPTY * len(schema[0])
    schema.insert(0, padding)
    schema.append(padding)
    # print_schema(schema)

    gear_ratios = find_gear_ratios(schema)
    print(sum(gear_ratios))


if __name__ == "__main__":
    main()
