#!/usr/bin/env python3
import fileinput
import re


def read_seeds_maps():
    lines = [l.rstrip("\n") for l in fileinput.input()]
    seeds = [int(n) for n in re.findall(r"\d+", lines[0])]

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


def seed2location(seed, maps):
    src = seed
    for m in range(len(maps)):
        for start_dst, start_src, range_len in maps[m]:
            if start_src <= src < start_src + range_len:
                src = start_dst + src - start_src
                break
    return src


def main():
    seeds, maps = read_seeds_maps()
    lowest_loc = min(seed2location(s, maps) for s in seeds)
    print(lowest_loc)


if __name__ == "__main__":
    main()
