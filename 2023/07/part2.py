#!/usr/bin/env python3
import fileinput
from enum import Enum
from collections import Counter


class HandType(Enum):
    FIVE_OF_A_KIND = 0
    FOUR_OF_A_KIND = 1
    FULL_HOUSE = 2
    THREE_OF_A_KIND = 3
    TWO_PAIR = 4
    ONE_PAIR = 5
    HIGH_CARD = 6
    NONE = 7


class Hand:

    def __init__(self, cards, bid):
        self._cards = cards
        self._card_values = Hand._value_cards(cards)
        self._type = Hand._calc_type(cards)
        self._bid = bid

    @staticmethod
    def _value_cards(cards):
        values = []
        for c in cards:
            match c:
                case "A":
                    v = 14
                case "K":
                    v = 13
                case "Q":
                    v = 12
                case "J":
                    v = 1
                case "T":
                    v = 10
                case _:
                    v = int(c)
            values.append(v)
        return values

    @staticmethod
    def _calc_type(cards):
        counter = Counter(cards)
        if 5 in counter.values():
            return HandType.FIVE_OF_A_KIND
        elif 4 in counter.values():
            if "J" in cards:  # Doesn't matter if it's 4 Js or 1 J.
                return HandType.FIVE_OF_A_KIND
            else:
                return HandType.FOUR_OF_A_KIND
        elif 3 in counter.values():
            if 2 in counter.values():
                if "J" in cards:
                    return HandType.FIVE_OF_A_KIND
                else:
                    return HandType.FULL_HOUSE
            else:
                if "J" in cards:
                    return HandType.FOUR_OF_A_KIND
                else:
                    return HandType.THREE_OF_A_KIND
        elif list(counter.values()).count(2) == 2:  # 2 pairs
            if counter["J"] == 2:
                return HandType.FOUR_OF_A_KIND
            elif counter["J"] == 1:
                return HandType.FULL_HOUSE
            else:
                return HandType.TWO_PAIR
        elif 2 in counter.values():
            if "J" in cards:
                return HandType.THREE_OF_A_KIND
            else:
                return HandType.ONE_PAIR
        elif "J" in cards:
            return HandType.ONE_PAIR
        else:
            return HandType.NONE

    def __str__(self):
        return f"Hand(cards={"".join(self._cards)}, bid={self._bid}, type={self._type})"

    __repr__ = __str__

    def _stronger_than(self, other):
        for c, c_other in zip(self._card_values, other._card_values):
            if c != c_other:
                return c > c_other
        return True

    def __lt__(self, other):
        v, v_other = self._type.value, other._type.value
        if v == v_other:
            return self._stronger_than(other)
        else:
            return v < v_other

    @property
    def bid(self):
        return self._bid


def read_hands():
    hands = []
    for line in fileinput.input():
        parts = line.rstrip("\n").split(" ")
        cards = list(parts[0])
        bid = int(parts[1])
        hands.append(Hand(cards, bid))
    return hands


def main():
    hands = read_hands()

    total_winnings = 0
    for rank, hand in enumerate(sorted(hands, reverse=True), start=1):
        total_winnings += hand.bid * rank
    print(total_winnings)


if __name__ == "__main__":
    main()
