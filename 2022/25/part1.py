#!/usr/bin/env python3
import fileinput

NUM_S2A = {
    "2": 2,
    "1": 1,
    "0": 0,
    "-": -1,
    "=": -2,
}


def read_snafus():
    return [list(line.rstrip("\n")) for line in fileinput.input()]


def numeral_snafu2arabic(num):
    return NUM_S2A[num]


def snafu2dec(snafu):
    dec = 0
    for i in range(len(snafu)):
        n = 5**i * numeral_snafu2arabic(snafu[-i - 1])
        dec += n
    return dec


def dec2snafu(dec):
    snafu = []
    while dec:
        r = dec % 5
        if r == 3:
            snafu.append("=")
            dec += 2  # overflow
        elif r == 4:
            snafu.append("-")
            dec += 1  # overflow
        else:
            snafu.append(str(r))
        dec //= 5
    return list(reversed(snafu))


def main():
    snaufs = read_snafus()
    sum_dec = 0
    for snafu in snaufs:
        sum_dec += snafu2dec(snafu)

    sum_snafu = dec2snafu(sum_dec)
    print("".join(sum_snafu))


if __name__ == "__main__":
    main()
