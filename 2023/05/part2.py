#!/usr/bin/env python3
import fileinput
import re
from functools import reduce


class MapFunction:
    def __init__(self, map):
        self._map = map

    def __call__(self, from_ranges):
        to_ranges = []
        for dest_start, src_start, range_len in self._map:
            src_end = src_start + range_len
            next_ranges = []  # Untranslated ranges for next iteration.
            while from_ranges:
                t_start, t_end = from_ranges.pop()
                uncov_before = MapFunction._range_uncovered_before(
                    t_start, t_end, src_start, src_end
                )
                cov = MapFunction._range_covered(t_start, t_end, src_start, src_end)
                uncov_after = MapFunction._range_uncovered_after(
                    t_start, t_end, src_start, src_end
                )
                if uncov_before:
                    next_ranges.append(uncov_before)
                if cov:
                    trans_step = dest_start - src_start
                    translated = (cov[0] + trans_step, cov[1] + trans_step)
                    to_ranges.append(translated)
                if uncov_after:
                    next_ranges.append(uncov_after)
            from_ranges = next_ranges

        # next_ranges has ranges not translated => should be as-is
        return to_ranges + next_ranges

    """"
   Overlapping cases in regards for r1 relative to r2:

   1. Contained
            [r1_start      r1_end)
    [r2_start                       r2_end)

   2. Covering
    [r1_start                       r2_end)
            [r2_start      r2_end)

   3. Non-contained end
            [r1_start               r1_end)
    [r2_start              r2_end)

   4. Non-contained start
    [r1_start              r1_end)
            [r2_start               r2_end)

   5. No overlap (left)
    [r1_start   r1_end)
                        [r2_start   r2_end)

   6. No overlap (right)
                        [r1_start   r2_end)
    [r2_start   r2_end)
   """

    @staticmethod
    def _range_uncovered_before(r1_start, r1_end, r2_start, _r2_end):
        """
        Find if there's a start section in r1 that is not covered by r2.
        """
        start = r1_start
        end = min(r1_end, r2_start)
        return (start, end) if start < end else None

    @staticmethod
    def _range_covered(r1_start, r1_end, r2_start, r2_end):
        """
        Find the section of r1 that is covered by r2.
        """
        start = max(r1_start, r2_start)
        end = min(r1_end, r2_end)
        return (start, end) if start < end else None

    @staticmethod
    def _range_uncovered_after(r1_start, r1_end, _r2_start, r2_end):
        """
        Find if there's an end section in r1 that is not covered by r2.
        """
        start = max(r1_start, r2_end)
        end = r1_end
        return (start, end) if start < end else None


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


# h/t https://www.reddit.com/r/adventofcode/comments/18b4b0r/comment/kc291gz/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
def main():
    seed_ranges, maps = read_seeds_maps()
    ranges = [(r[0], r[0] + r[1]) for r in seed_ranges]
    functions = [MapFunction(map) for map in maps]

    translated_ranges = reduce(lambda r, f: f(r), functions, ranges)
    min_location = min(translated_ranges)[0]
    print(min_location)


if __name__ == "__main__":
    main()
