#!/usr/bin/env python3
"""
h/t https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/kepu26z/
who discovered that we actually only need to consider 4 trajectories; the rock's and 3 other random hailstones.

Let's say that the rock has initial initial position p_r (vector in variables
(x, z, z))and velocity v_r (v_xr, v_yr, v_zr). Then as the rock will hit all
hailstones, we know that the position of the rock will be the same as the hail
for a given t. Let there be i=[0, n] hailstones, and then the time they will
intersect with the rock is at time t_i:

p_r + v_r * t_i = p_i + v_i * t_i (1) for all i.

Rearranging (1) we get
(p_r - p_i) = -t_i * (v_r - v_i) (2)

Because t_i is a scalar in (2), ite means lhs and rhs are parallel,or in other
words, if one vector is a scalar multiple of the other. A property of parallel
vectors is that their cross product is 0. Thus we have (op 'x' means cross product):

(p_r - p_i) x (v_r - v_i) = 0 (3)

(3) is the key to solve this problem. (3) is a bilinear system of equations in
the variables p_r and v_r, as we know all the p_i and v_i for t_0. Thus let's
only work in t_0 (time = 0) from now on. It's bilinear as the variables
(x_r, y_r, z_r, v_xr, v_yr, v_zr) in this system belongs to two sets: p_r and v_r.

Rearranging (3), as the distributive property is valid also for vector cross products:

(p_r x v_r) = (p_r x v_i) + (p_i x v_r) + (p_i x v_i) (4)

Lhs in (4) is the same for all rock-hailstone collision equations. Thus we can
equate two equations with each other on this term. If we do this for two
different pairs, say i=0 (A) with i=1 (B) and i=0 with i=2 (C), then we get a system of
equations having 6 equations and 6 variables. Dimension of 6 because as each
pair has 3 equations (one for each axis) expressed in the
6 variables (x, y, z, v_x, v_y, v_z). Taking equating these pairs we have this system:

| (p_r x v_A) + (p_A x v_r) - (p_A x v_A) = (p_r x v_B) + (p_B x v_r) - (p_B x v_B)| (5)
| (p_r x v_A) + (p_A x v_r) - (p_A x v_A) = (p_r x v_C) + (p_B x v_C) - (p_B x v_C)|

<=> Rearranging the first equation (5) to parametric form gives us:
-(p_A x v_A) + (p_B x v_B) = p_r x (v_B - v_A) + (p_B - p_A) x v_r
<=> with vector cross products: a × b = - (b × a), so we can get rhs variables on the same form.
-(p_A x v_A) + (p_B x v_B) = (v_A - v_B) x p_r + (p_B - p_A) x v_r (6)

Rearranging (5) in the form of (6) we hae our system of bilinear equations:

| -(p_A x v_A) + (p_B x v_B) = (v_A - v_B) x p_r + (p_B - p_A) x v_r | (7)
| -(p_A x v_A) + (p_C x v_C) = (v_A - v_C) x p_r + (p_C - p_A) x v_r|

From this (y) system of equations we can set up to solve for the unknown variables, namely the initial position and velocity of the rocket!
If put the problem in the form of Ax=B, then with numpy we can solve for x with:
x = numpy.linalg.solve(A, b)

The vector x (6x1) is simply our unknown variables:
    |x_r |
    |y_r |
x = |z_r |
    |v_xr|
    |v_yr|
    |v_zr|

The vector b (6x1) is the lhs of (7) (all values are known for us at t_0) (each equation expands to 3 sub-equations):
b = | -(p_A x v_A) + (p_B x v_B) |
    | -(p_A x v_A) + (p_C x v_C) |


The matrix A (6x6) is the rhs of (7) (all values are known for us at t_0) (each equation expands to 3 sub-equations).
Since each term e.g. (v_A - v_B) is cross product'd with it's variable (here p_r) we must convert this cross product to matrix form according to
https://en.wikipedia.org/wiki/Cross_product#Conversion_to_matrix_multiplication
This means that A will be a cross matrix (a matrix with 4 section) like

A = |A_1 A_2|
    |A_3 A_4|

where each A_n (3x3) is the skew-symmetric matrix as described in the wikipedia article. i.e.

A_1 = cross_matrix(v_A - v_B) = cross_matrix(v_A) - cross_matrix(v_B)
A_2 = cross_matrix(p_B - p_A) = cross_matrix(p_B) - cross_matrix(p_A)
A_3 = cross_matrix(v_A - v_C) = cross_matrix(v_A) - cross_matrix(v_C)
A_4 = cross_matrix(p_C - p_A) = cross_matrix(p_C) - cross_matrix(p_A)

e.g.

                    |  0   -v_zA  v_yA |
cross_matrix(v_A) = | v_zA   0   -v_xA |
                    |-v_yA  v_xA   0   |



Now just
x = numpy.linalg.solve(A, b)
and get the rock's initial position at x_r = x[0], y_r = x[1], x_z = x[2]!
"""

import fileinput
import re
import sys

import numpy as np


SPLIT_PATTERN = re.compile(r", | @ ")

# Found by investigation...
ACCEPTABLE_MATRIX_CONDITION = 5000000000000

def read_trajectories():
    trajectories = []
    for line in fileinput.input():
        x0, y0, z0, kx, ky, kz = [np.float64(int(d)) for d in re.split(SPLIT_PATTERN, line)]
        trajectories.append(((x0, y0, z0), (kx, ky, kz)))
    return trajectories


# Ref: https://en.wikipedia.org/wiki/Cross_product#Conversion_to_matrix_multiplication
# Ref: https://stackoverflow.com/a/77592247/265508
def cross_product_matrix(vector):
    I = np.eye(len(vector))
    return np.cross(I, vector)


def trajectory_collides_all(trajectories):
    # Due to nasty floating point rounding (off-by-2 !), let's search for a Matrix with acceptable condition (= less likely to get rounding errors) by trying different pairs of trajectories.
    # Using np.float128 (together with scipy.linalg.solve() as numpy's does not deal with float128) did not help. Also it did not help to shift all x,y,z values in tr1,tr2,tr3 with the minimum of their values.
    i = 0
    while i  < len(trajectories) - 2:
        tr1, tr2, tr3 = trajectories[i:i+3]

        A1 = cross_product_matrix(tr1[1]) - cross_product_matrix(tr2[1])
        A2 = cross_product_matrix(tr2[0]) - cross_product_matrix(tr1[0])
        A3 = cross_product_matrix(tr1[1]) - cross_product_matrix(tr3[1])
        A4 = cross_product_matrix(tr3[0]) - cross_product_matrix(tr1[0])
        A = np.block([[A1, A2], [A3, A4]])

        if np.linalg.cond(A) <= ACCEPTABLE_MATRIX_CONDITION:
            break
        i += 1

    if i == len(trajectories) - 2:
         sys.exit("No coefficient matrix with acceptable condition could be found.")

    b1 = -np.cross(tr1[0], tr1[1]) + np.cross(tr2[0], tr2[1])
    b2 = -np.cross(tr1[0], tr1[1]) + np.cross(tr3[0], tr3[1])
    b = np.concat((b1, b2))

    x = np.linalg.solve(A, b)

    # We can only have integer coordinates and velocities in this problem.
    x = [np.rint(n).astype('int') for n in x]

    # Return in the trajectory format as input was read for consistency.
    return (x[0:3], x[3:])

def main():
    trajectories = read_trajectories()
    stone_tr = trajectory_collides_all(trajectories)
    coord_sum = sum(stone_tr[0])
    print(coord_sum)

if __name__ == '__main__':
	main()
