#!/usr/bin/env python3
import fileinput

import z3

MONKEY_ROOT = "root"
MONKEY_HUMAN = "humn"


def read_monkies():
    monkies = {}
    for line in fileinput.input():
        parts = line.rstrip("\n").split(" ")
        monkey = parts[0][:-1]
        if len(parts) == 2:
            monkies[monkey] = [int(parts[1])]
        else:
            monkies[monkey] = parts[1:]
    return monkies


def compute(lhs, op, rhs):
    match op:
        case "+":
            return lhs + rhs
        case "-":
            return lhs - rhs
        case "*":
            return lhs * rhs
        case "/":
            return lhs / rhs
        case _:
            raise (f"Unknown operator {op}")


# Post-order tree traversal.
def value_of(monkies, monkey):
    if monkey == MONKEY_HUMAN:
        raise "Can't eval human"
    task = monkies[monkey]
    if len(task) == 1:
        return task[0]
    else:
        lhs = value_of(monkies, task[0])
        rhs = value_of(monkies, task[2])
        return compute(lhs, task[1], rhs)


def compute_condition(solver, var, lhs, op, rhs):
    match op:
        case "+":
            solver.add(lhs + rhs == var)
        case "-":
            solver.add(lhs - rhs == var)
        case "*":
            solver.add(lhs * rhs == var)
        case "/":
            solver.add(lhs / rhs == var)
        case _:
            raise (f"Unknown operator {op}")


def add_conditions(solver, monkies, monkey):
    var = z3.Int(monkey)

    if monkey == MONKEY_HUMAN:
        solver.add(var == var)
        return var

    task = monkies[monkey]
    if len(task) == 1:
        solver.add(var == task[0])
    else:
        lhs = add_conditions(solver, monkies, task[0])
        rhs = add_conditions(solver, monkies, task[2])
        compute_condition(solver, var, lhs, task[1], rhs)
    return var


def main():
    monkies = read_monkies()
    monkies[MONKEY_ROOT][1] = "="

    # Calculate the target_value of the sub-tree of root that doesn't have the humn in it.
    tree_left = monkies[MONKEY_ROOT][0]
    tree_right = monkies[MONKEY_ROOT][2]

    value_left = None
    value_right = None
    try:
        value_left = int(value_of(monkies, tree_left))
    except Exception:
        value_right = int(value_of(monkies, tree_right))

    if value_left is None:
        tree_human = tree_left
        target_value = value_right
    else:
        tree_human = tree_right
        target_value = value_left

    # Now create conditions and let Z3 find the value of the only unknown variable, humn.
    solver = z3.Solver()
    var = add_conditions(solver, monkies, tree_human)
    solver.add(var == target_value)

    if solver.check():
        model = solver.model()
        var_humn = z3.Int(MONKEY_HUMAN)
        print(model[var_humn])
    else:
        print("Not solvable")


if __name__ == "__main__":
    main()
