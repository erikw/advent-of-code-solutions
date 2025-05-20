#!/usr/bin/env python3
import fileinput
from pprint import pprint
import re
import itertools

import numpy as np
from termcolor import colored

# XY_MIN = 7
# XY_MAX = 27

XY_MIN = 200000000000000
XY_MAX = 400000000000000

"""
We are given a list of linear trajectories in two dimensions on x and y axis, given x_0 and y_0 for t=0, and the slope for each axis.
E.g.
Hailstone A: 19, 13, 30 @ -2, 1, -2
Hailstone B: 18, 19, 22 @ -1, -1, -2

Each hailstone can be written as a function of the time:
H(t) =
{
    x(t) = k_x * t + x_0
    y(t) = k_y * t + y_0
}
=
|x(t)| = |k_x| * t + |x_0|
|y(t)|   |k_y|       |y_0|


e.g.
H_a(t) =
{
    x_a(t) = -2t + 19
    y_a(t) = t + 13
}
=
|x_a(t)| = |-2| * t + |19|
|y_a(t)|   |1|        |13|

H_b(t) =
{
    x_b(t) = -t + 18
    y_b(t) = -t + 19
}
=
|x_b(t)| = |-1| * t + |18|
|y_b(t)|   |-1|       |19|

It's not about solving a system of equations for variable t i.e. the hailstones actually necessarily collide.
Instead it's to see if their trajectories intersect at two possible different times t_a and t_b.
Thus, we can see at which (x,y) both trajectories meet by setting up a system of 4 linear equations if 4 variables (x, y, t_a, t_b)

H_a(t_a) = H_a(t_b)
<=>
x = k_xa * t_a + x_0a
y = k_ya * t_a + y_0a
x = k_xb * t_b + x_0b
y = k_yb * t_b + y_0b
<=> (parametric form)
x - k_xa * t_a = x_0a
y - k_ya * t_a = y_0a
x - k_xb * t_b = x_0b
y - k_yb * t_b = y_0b
<=> (verbose, add missing variables)
1 * x + 0 * y - k_xa * t_a + 0 * t_b = x_0a
0 * x + 1 * y - k_ya * t_a + 0 * t_b = y_0a
1 * x + 0 * y + 0 * t_a - k_xb * t_b = x_0b
0 * x + 1 * y + 0 * t_a - k_yb * t_b = y_0b

Solving this system of linear equations gives us the desired (x,y) for which the trajectories intersect, at two likely distinct times t_a and t_b.
numpy.linalg.solve(A, b) solves A*x=b where: A - coefficient matrix, x - vector of unknowns , b - constants vector:

    |1    0  -k_xa    0   |
A = |0    1  -k_ya    0   |
    |1    0    0    -k_xb |
    |0    1    0    -k_yb |

    [ x |
x = | y |
    |t_A|
    |t_B]

    |x_0a|
b = |y0_a|
    |x0_b|
    |y0_b|
"""

SPLIT_PATTERN = re.compile(r", | @ ")

def read_trajectories():
    trajectories = []
    for line in fileinput.input():
        x0, y0, z0, kx, ky, kz = [int(d) for d in re.split(SPLIT_PATTERN, line)]
        trajectories.append(((x0, y0, z0), (kx, ky, kz)))
    return trajectories


def print_status(tr1, tr2, i1, i2, vars):
    name1 = chr(ord('A') + i1)
    name2 = chr(ord('A') + i2)
    print(f"Hailstone {name1}: {tr1[0]} @ {tr1[1]}")
    print(f"Hailstone {name2}: {tr2[0]} @ {tr2[1]}")
    if name1 == "A" and name2 == "E":
        pass
    match vars:
        case None:
            print("Hailstones' paths are parallel; they never intersect.")
        case (x, y, t1, t2) if t1 < 0 and t2 < 0:
            print("Hailstones' paths crossed in the past for both hailstones.")
        case (x, y, t1, _) if t1 < 0:
            print(f"Hailstones' paths crossed in the past for hailstone {name1}.")
        case (x, y, _, t2) if t2 < 0:
            print(f"Hailstones' paths crossed in the past for hailstone {name2}.")
        case (x, y, _, _) if XY_MIN <= x <= XY_MAX and XY_MIN <= y <= XY_MAX:
            print(f"Hailstones' paths will cross {colored("inside", attrs=["bold"])} the test area (at x={x:.5g}, y={y:.5g}).")
        case (x, y, _, _):
            print(f"Hailstones' paths will cross outside the test area (at x={x:.5g}, y={y:.5g}).")
        case _:
            print("Should not happen!")


def trajectory_intersection(t1, t2):
    A = np.array((
         (1, 0, -t1[1][0], 0),
         (0, 1, -t1[1][1], 0),
         (1, 0, 0, -t2[1][0]),
         (0, 1, 0, -t2[1][1]),
         ))
    b = np.array((t1[0][0], t1[0][1], t2[0][0], t2[0][1]))
    try:
        x = np.linalg.solve(A, b)
    except np.linalg.LinAlgError:
         return None
    else:
        return [v.item() for v in x] # [x, y, t_a, t_b]


def main():
    trajectories = read_trajectories()
    # pprint(trajectories)

    inside = 0
    for (i1, tr1), (i2, tr2) in itertools.combinations(enumerate(trajectories), 2):
        vars = trajectory_intersection(tr1, tr2)
        # print_status(tr1, tr2, i1, i2, vars)
        if vars:
            x, y, t1, t2 = vars
            if (XY_MIN <= x <= XY_MAX and
                XY_MIN <= y <= XY_MAX and
                t1 >= 0 and
                t2 >= 0):
                inside += 1
    print(inside)
if __name__ == '__main__':
	main()
