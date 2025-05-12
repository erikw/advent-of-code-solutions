#!/usr/bin/env python3
import sys
import operator
from pprint import pprint


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

        workflows = {}
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


def process_parts(workflows, ratings):
    accepted = []
    for rating in ratings:
        workflow = WORKFLOW_START
        while workflow not in [WORKFLOW_ACCEPT, WORKFLOW_REJECT]:
            for step in workflows[workflow]:
                if len(step) == 1:
                    workflow = step[0]
                else:
                    category, cmp, value, target = step
                    if OP_FUNCS[cmp](rating[category], value):
                        workflow = target
                        break
        if workflow == WORKFLOW_ACCEPT:
            accepted.append(rating)
    return accepted



def main():
    workflows, ratings = read_input()
    accepted = process_parts(workflows, ratings)

    rating_sum = sum([sum(a.values()) for a in accepted])
    print(rating_sum)

if __name__ == '__main__':
	main()
