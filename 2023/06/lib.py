from math import floor, ceil, sqrt, prod


"""
* In general: distance = velocity * time (1)
* In our case; the (2)
   velocity = time_button_pressed
   time = total_race_time - time_button_pressed
* Plugging (2) into (1) and renaming varialbes to d, v and t
    d = v * (t - v) = -v^2 + tv
    an quadratic 2nd degree equation! It is a parabola with a maxima,
    https://www.wolframalpha.com/input?i=f%28v%29+%3D+-v%5E2+%2B+v
* Rewrite to standard x/y variables:
    y = -x^2 +tx
* As we know the record distance (y) we just need to calculate for which two x
  values (x1 and x2) the curve intersects this maxima. Then our answer is all
  integers xs between these x1 and x2. Thus, solve for x given a y!
    y = -x^2 +tx <=>
    0 = -x^2 +tx - y (3)
* Remembering the standard formula for a 2nd degree equation:
    y = a^2 + bx + c (4)
* We see that if we put (3) in the form of (4), then we will have
    (5)
    a = -1
    b = t
    c = -y
* Remembering that the formula to for solving x in (4) is:
    x_1, x_2 = (-b +/- sqrt(b^2 - 4ac)) / 2 (6)
* Plugging (5) into (6) we get:
    x_1, x_2 = (-t +/- sqrt(t^2 - 4y)) / 2 <=>
    x_1, x_2 = t/2 +/- sqrt(t^2 - 4y) / 2 (7)
* With (7) we can now directly get the two x values (button press lengths) that were used when the record distance y was set.
"""


def times_for_time_distance(time, distance):
    x1 = time / 2 + sqrt(time**2 - 4 * distance) / 2
    x2 = time / 2 - sqrt(time**2 - 4 * distance) / 2
    return sorted((x1, x2))


def win_possibilities(time, record_distance):
    x1, x2 = times_for_time_distance(time, record_distance)

    # if x1.is_integer() x1=x1+1 else x1+=1. Or more simply:
    x1 = floor(x1 + 1)
    # In the same way...
    x2 = ceil(x2 - 1)

    return x2 - x1 + 1
