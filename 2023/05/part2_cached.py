#!/usr/bin/env python3
# NOPE this is too memory-intensive: cache is too large.
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


def seed2location(seed, maps, maps_cache):
    src = seed
    for m in range(len(maps)):
        if not src in maps_cache[m]:
            maps_cache[m][src] = src
            for start_dest, start_src, range_len in maps[m]:
                if start_src <= src < start_src + range_len:
                    maps_cache[m][src] = start_dest + src - start_src
                    src = maps_cache[m][src]
                    break
    return src


def main():
    seed_ranges, maps = read_seeds_maps()
    pprint(seed_ranges)

    locations = {}  # cache: seed -> location
    maps_cache = [{} for _ in range(len(maps))]
    for seed_start, seed_range in seed_ranges:
        print(f"At seed start {seed_start} with range {seed_range}")
        for seed in range(seed_start, seed_start + seed_range):
            if not seed in locations:
                locations[seed] = seed2location(seed, maps, maps_cache)
    location_lowest = min(locations.values())
    print(location_lowest)


if __name__ == "__main__":
    main()
