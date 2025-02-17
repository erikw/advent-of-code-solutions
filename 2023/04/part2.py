#!/usr/bin/env python3
import fileinput
import re
from collections import Counter


def extract_numbers(line):
    return [int(d) for d in re.findall(r"\d+(?:\s|$)", line)]


def wins_for_card(line):
    nbrs_winning, nbrs_mine = (set(extract_numbers(ns)) for ns in line.split("|"))
    wins = nbrs_winning.intersection(nbrs_mine)
    return len(wins)


def scratch(card_wins):
    cards_total = Counter({i: 1 for i in range(len(card_wins))})

    for i, wins in enumerate(card_wins):
        for j in range(wins):
            cards_total[i + j + 1] += cards_total[i]

    return cards_total.total()


def main():
    card_wins = [wins_for_card(line) for line in fileinput.input()]
    cards_total = scratch(card_wins)
    print(cards_total)


if __name__ == "__main__":
    main()
