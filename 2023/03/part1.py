#!/usr/bin/env python3
import fileinput
from pprint import pprint

SCHEMA_EMPTY = "."


def print_schema(schema):
    for row in schema:
        print(row)


def is_symbol(schema, row, col):
    return not schema[row][col].isdigit() and schema[row][col] != SCHEMA_EMPTY


def get_part_number(schema, row, col):
    if not schema[row][col].isdigit():
        return None

    nbr_len = 1
    while schema[row][col + nbr_len].isdigit():
        nbr_len += 1

    # NOTE we could make this more efficient by not checking the found number [row, row+nbr_len]...
    for adj_row in range(row - 1, row + 2):
        for adj_col in range(col - 1, col + nbr_len + 1):
            adj = schema[adj_row][adj_col]
            if is_symbol(schema, adj_row, adj_col):
                return schema[row][col : col + nbr_len]
    return None


def find_part_numbers(schema):
    row_start = 1
    row_len = len(schema) - 1
    col_start = 1
    col_len = len(schema[0]) - 1

    part_nbrs = []
    row = row_start
    while row < row_len:
        col = col_start
        while col < col_len:
            part_nbr_s = get_part_number(schema, row, col)
            if part_nbr_s:
                col += len(part_nbr_s)
                part_nbrs.append(int(part_nbr_s))
            else:
                col += 1
        row += 1
    return part_nbrs


def main():
    schema = []
    for row in fileinput.input():
        schema.append(SCHEMA_EMPTY + row.rstrip("\n") + SCHEMA_EMPTY)
    padding = SCHEMA_EMPTY * len(schema[0])
    schema.insert(0, padding)
    schema.append(padding)
    # print_schema(schema)

    part_nbrs = find_part_numbers(schema)
    print(sum(part_nbrs))


if __name__ == "__main__":
    main()
