#!/usr/bin/env python3
# Memoization version.

import fileinput

SPRING_OPERATIONAL = "."
SPRING_DAMAGED = "#"
SPRING_UNKNOWN = "?"

FOLDS = 5

def read_condition_records():
    recs = []
    for line in fileinput.input():
        springs, damage_groups = line.rstrip("\n").split()
        damage_groups = tuple(int(g) for g in damage_groups.split(","))
        recs.append((springs, damage_groups))
    return recs

def unfold_records(records):
    recs_unfolded = []
    for springs, damage_groups in records:
        springs = SPRING_UNKNOWN.join(springs for _ in range(FOLDS))
        damage_groups = damage_groups * FOLDS
        recs_unfolded.append((springs, damage_groups))
    return recs_unfolded

def count_arrangements(springs, damage_groups, memo={}):
    memo_key = springs + str(damage_groups)

    if memo_key not in memo:
        if len(damage_groups) == 0:
            if SPRING_DAMAGED in springs:
                memo[memo_key] = 0
            else:
                memo[memo_key] = 1
        elif len(springs) == 0:
            memo[memo_key] = 0
        else:
            dmg_group = damage_groups[0]
            arrangements_insert = 0
            arrangements_skip = 0

            if dmg_group <= len(springs) and SPRING_OPERATIONAL not in springs[:dmg_group] and (dmg_group == len(springs) or springs[dmg_group] != SPRING_DAMAGED):
                arrangements_insert = count_arrangements(springs[dmg_group + 1:], damage_groups[1:], memo=memo)

            if springs[0] != SPRING_DAMAGED:
                arrangements_skip = count_arrangements(springs[1:], damage_groups, memo=memo)

            memo[memo_key] = arrangements_insert + arrangements_skip
    return memo[memo_key]

def main():
    condition_records = read_condition_records()
    condition_records = unfold_records(condition_records)

    arrangements_sum = sum(count_arrangements(*rec) for rec in condition_records)
    print(arrangements_sum)

if __name__ == '__main__':
	main()
