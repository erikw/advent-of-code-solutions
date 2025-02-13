#!/usr/bin/env python3
import fileinput

MAX_CUBES = {"red": 12, "green": 13, "blue": 14}


def possible_cube(cube):
    amount, color = cube.strip().split(" ")
    return int(amount) <= MAX_CUBES[color]


def possible_game(game):
    cubes = game.split(",")
    return all(map(possible_cube, cubes))


def main():
    id_sum = 0
    for line in fileinput.input():
        p_game, p_data = line.rstrip("\n").split(":")
        id = int(p_game.split(" ")[-1])

        games = p_data.split(";")
        if all(map(possible_game, games)):
            id_sum += id
    print(id_sum)


if __name__ == "__main__":
    main()
