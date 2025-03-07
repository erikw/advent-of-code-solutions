#!/usr/bin/env python3
import fileinput
from pprint import pprint
from enum import Enum

class HandType(Enum):
    FIVE_OF_A_KIND = 0
    FOUR_OF_A_KIND = 1
    FULL_HOUSE = 2
    THREE_OF_A_KIND = 3
    TWO_PAIR = 4
    ONE_PAIR = 5
    HIGH_CARD = 6


class Hand():

    # TYPES = [
    #      FIVE_OF_A_KIND,
    #      FOUR_OF_A_KIND,
    #      FULL_HOUSE,
    #      THREE_OF_A_KIND,
    #      TWO_PAIR,
    #      ONE_PAIR,
    #      HIGH_CARD,
    # ]

    def __init__(self, cards, bid):
        self._cards = cards
        self._bid = bid
        self._type = Hand._calc_type()
        
    @staticmethod
    def _calc_type():
        pass

    def __str__(self):
        return f"Hand(cards={"".join(self._cards)}, bid={self._bid})"
    
    __repr__ = __str__


    def __lt__(self, other):
        return self._type < other._type




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
    pprint(hands)

    total_winnings = 0
    for hand, rank in enumerate(sorted(hands, reverse=True), start=1):
        print("Hand {hand} has rank {rank} => winning of {hand.bid * rank}")
        total_winnings += hand.bid * rank
    print(total_winnings)

if __name__ == '__main__':
	main()	
