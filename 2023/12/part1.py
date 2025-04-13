#!/usr/bin/env python3
import fileinput

SPRING_OPERATIONAL = "."
SPRING_DAMAGED = "#"
SPRING_UNKNOWN = "?"

def read_condition_records():
    recs = []
    for line in fileinput.input():
        springs, damage_groups = line.rstrip("\n").split()
        damage_groups = tuple(int(g) for g in damage_groups.split(","))
        recs.append((springs, damage_groups))
    return recs


def count_arrangements(springs, damage_groups):
    if len(damage_groups) == 0:
        return 0 if SPRING_DAMAGED in springs else 1
    elif len(springs) == 0:
        return 0
    else:
        dmg_group = damage_groups[0]
        arrangements_insert = 0
        arrangements_skip = 0

        if dmg_group <= len(springs) and SPRING_OPERATIONAL not in springs[:dmg_group] and (dmg_group == len(springs) or springs[dmg_group] != SPRING_DAMAGED):
            arrangements_insert = count_arrangements(springs[dmg_group + 1:], damage_groups[1:])

        if springs[0] != SPRING_DAMAGED:
            arrangements_skip = count_arrangements(springs[1:], damage_groups)

        return arrangements_insert + arrangements_skip

def main():
    condition_records = read_condition_records()
    arrangements_sum = sum(count_arrangements(*rec) for rec in condition_records)
    print(arrangements_sum)

if __name__ == '__main__':
	main()
