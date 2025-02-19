#!/usr/bin/env python3
# NOPE this is too memory-intensive: the DP table requires 27GB in theory, more in real-world it seems.
import fileinput
import re
from pprint import pprint


def read_seeds_maps():
    lines = [l.rstrip("\n") for l in fileinput.input()]
    seeds = [
        tuple(int(n) for n in x.split(" ")) for x in re.findall(r"\d+\s\d+", lines[0])
    ]

    maps = []
    m = -1
    i = 1
    while i < len(lines):
        if not lines[i]:
            maps.append([])
            m += 1
            i += 2
        else:
            nbrs = tuple(int(n) for n in lines[i].split(" "))
            maps[m].append(nbrs)
            i += 1
    return (seeds, maps)


def seed2location_dp(seed, maps_dp):
    src = seed
    for m in range(len(maps_dp)):
        if src in maps_dp[m]:
            src = maps_dp[m][src]
    return src


def precompute_maps(maps):
    DP = [None] * len(maps)

    for m in range(len(maps)):
        DP[m] = {}
        for start_dst, start_src, range_len in maps[m]:
            diff = start_dst - start_src
            for src in range(start_src, start_src + range_len):
                DP[m][src] = src + diff
    return DP


def main():
    seed_ranges, maps = read_seeds_maps()

    # # calc max ranges DP size
    # rngs = []
    # for map in maps:
    #     map_rngs = 0
    #     for dst, src, rng in map:
    #         map_rngs += rng
    #     rngs.append(map_rngs)
    # print(max(rngs))
    # return

    maps_dp = precompute_maps(maps)
    print("Precomp completed")

    locations = []
    for seed_start, seed_range in seed_ranges:
        print(f"At start {seed_start} with range {seed_range}")
        for seed in range(seed_start, seed_start + seed_range):
            location = seed2location_dp(seed, maps_dp)
            # print(f"looking at seed {seed}, it has loc {location}")
            locations.append(location)
    # pprint(locations)
    location_lowest = min(locations)
    print(location_lowest)


if __name__ == "__main__":
    main()
