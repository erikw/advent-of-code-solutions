#!/usr/bin/env python3
# Problem type: Resource-Constrained Production Optimization. However we brute force but with keeping only the top best promising production paths so far.
# h/t https://www.reddit.com/r/adventofcode/comments/zpihwi/comment/j0tvzgz/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

import fileinput
import re

TOTAL_MIN = 24
BEST_THRESHOLD = 1000

BLUEPRINT_PATTERN = re.compile(r"\d+")


def read_blueprints():
    blueprints = []
    for line in fileinput.input():
        ns = list(map(int, re.findall(BLUEPRINT_PATTERN, line)))
        blueprint = (
            ns[0],
            (
                # (cost, robot_prod)
                ((ns[1], 0, 0, 0), (1, 0, 0, 0)),  # ore robot
                ((ns[2], 0, 0, 0), (0, 1, 0, 0)),  # clay robot
                ((ns[3], ns[4], 0, 0), (0, 0, 1, 0)),  # obsidian robot
                ((ns[5], 0, ns[6], 0), (0, 0, 0, 1)),  # geode robot
                ((0, 0, 0, 0), (0, 0, 0, 0)),  # make no robot
            ),
        )
        blueprints.append(blueprint)
    return blueprints


def keep_best(states):
    return sorted(
        states,
        key=lambda e: tuple(reversed(tuple(c + r for c, r, in zip(*e))))
        + tuple(reversed(e[1])),
        reverse=True,
    )[:BEST_THRESHOLD]


def max_geode(blueprint, total_time):
    states = [
        tuple([(0, 0, 0, 0), (1, 0, 0, 0)])
    ]  # States/paths to consider (resources, robots)

    for t in range(total_time):
        states_next = []
        for resources, robots in states:
            for cost, robot_prod in blueprint:
                if all(c <= r for c, r in zip(cost, resources)):
                    resources_next = tuple(
                        re - c + ro for re, c, ro in zip(resources, cost, robots)
                    )
                    robots_next = tuple(ro + rp for ro, rp in zip(robots, robot_prod))
                    states_next.append(tuple([resources_next, robots_next]))
        states = keep_best(states_next)
    return max(s[0][-1] for s in states)


def main():
    quality_sum = 0
    for id, blueprint in read_blueprints():
        quality_sum += max_geode(blueprint, TOTAL_MIN) * id
    print(quality_sum)


if __name__ == "__main__":
    main()
