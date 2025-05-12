#!/usr/bin/env python3
import sys
import operator
from pprint import pprint
import copy
from math import prod


RANGE_MIN = 1
RANGE_MAX = 4000

WORKFLOW_START = "in"
WORKFLOW_ACCEPT = "A"
WORKFLOW_REJECT = "R"

OP_FUNCS = {
    "<" : operator.lt,
    ">" : operator.gt,
}

def read_input():
    with open(sys.argv[1]) as file:
        workflow_lines, rating_lines = file.read().split("\n\n")

        # Add Accpet/Reject as own workflows to make recursion easier.
        workflows = { 
            WORKFLOW_ACCEPT: (WORKFLOW_ACCEPT,),
            WORKFLOW_REJECT: (WORKFLOW_REJECT,),
        }
        for workflow_line in workflow_lines.split("\n"):
            name, rules = workflow_line.split("{")
            workflows[name] = []
            for rule in rules[:-1].split(","):
                if ":" in rule:
                    condition, target = rule.split(":")
                    category, cmp, value = condition[0], condition[1], int(condition[2:])
                    workflows[name].append((category, cmp, value, target))
                else:
                    workflows[name].append((rule,))

            ratings = []
            for rating_line in rating_lines.strip().split("\n"):
                #  ratings.append({k:v for k, v in zip(["x", "m", "a", "s",], re.findall(r"\d+", rating_line))})
                ratings.append({})
                for rating in rating_line.strip("{}").split(","):
                    category, value = rating.split("=")
                    ratings[-1][category] = int(value)

        return workflows, ratings


# Ranges are inclusive
def find_acceptable_ranges(workflows, workflow=WORKFLOW_START, step=0, ranges={"x": [RANGE_MIN, RANGE_MAX], "m": [RANGE_MIN, RANGE_MAX], "a": [RANGE_MIN, RANGE_MAX], "s": [RANGE_MIN, RANGE_MAX]}):
    workflow_step = workflows[workflow][step]
    if len(workflow_step) == 1:
        if workflow_step[0] == WORKFLOW_ACCEPT:
            return [ranges]
        elif workflow_step[0] == WORKFLOW_REJECT:
            return []
        else:
            return find_acceptable_ranges(workflows, workflow_step[0], 0, ranges)

    category, cmp, value, target = workflow_step

    # Recurse for step condition true
    ranges_cond_true = []
    ranges_rec_true = copy.deepcopy(ranges)
    if cmp == "<":
        ranges_rec_true[category][1] = min(ranges_rec_true[category][1], value - 1)
        if ranges_rec_true[category][1] < ranges_rec_true[category][0]:
            ranges_rec_true = None
    else:
        ranges_rec_true[category][0] = max(ranges_rec_true[category][0], value + 1)
        if ranges_rec_true[category][0] > ranges_rec_true[category][1]:
            ranges_rec_true = None
    if ranges_rec_true:
        ranges_cond_true = find_acceptable_ranges(workflows, target, 0, ranges_rec_true)


    # Recurse for step condition false
    ranges_cond_false = []
    ranges_rec_false = copy.deepcopy(ranges)
    if cmp == "<":
        ranges_rec_false[category][0] = max(ranges_rec_false[category][0], value)
        if ranges_rec_false[category][0] > ranges_rec_false[category][1]:
            ranges_rec_false = None
    else:
        ranges_rec_false[category][1] = min(ranges_rec_false[category][1], value)
        if ranges_rec_false[category][1] < ranges_rec_false[category][0]:
            ranges_rec_false = None
    if ranges_rec_false:
        ranges_cond_false = find_acceptable_ranges(workflows, workflow, step + 1, ranges_rec_false)

    return ranges_cond_true + ranges_cond_false



def main():
    workflows = read_input()[0]
    ranges = find_acceptable_ranges(workflows)

    combinations = sum(prod((hi - lo + 1 for lo, hi in range.values())) for range in ranges)
    print(combinations)

if __name__ == '__main__':
	main()
