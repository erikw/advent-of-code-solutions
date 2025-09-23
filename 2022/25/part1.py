#!/usr/bin/env python3
import fileinput

# Numeral SNAFU to arabic
NUM_S2A = {
    "2": 2,
    "1": 1,
    "0": 0,
    "-": -1,
    "=": -2,
}

# Numeral arabic to SNAFU
NUM_A2S = {
    0: "0",
    1: "1",
    2: "2",
    3: "=",
    4: "-",
}


def read_snafus():
    return [line.rstrip("\n") for line in fileinput.input()]


def snafu2dec(snafu):
    dec = 0
    for i in range(len(snafu)):
        n = 5**i * NUM_S2A[snafu[-i - 1]]
        dec += n
    return dec


def dec2snafu(dec):
    snafu = []
    while dec:
        r = dec % 5
        snafu.append(NUM_A2S[r])
        # Add carry-over
        if r == 3:
            dec += 2
        elif r == 4:
            dec += 1
        dec //= 5
    return "".join(reversed(snafu))


def main():
    snaufs = read_snafus()

    sum_dec = 0
    for snafu in snaufs:
        sum_dec += snafu2dec(snafu)

    sum_snafu = dec2snafu(sum_dec)
    print(sum_snafu)


if __name__ == "__main__":
    main()
