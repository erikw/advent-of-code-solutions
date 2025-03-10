#!/usr/bin/env python3
import fileinput


def read_input():
    return [[int(d) for d in l.rstrip("\n").split(" ")] for l in fileinput.input()]


def predict_next(value_history):
    predict = [value_history]

    while not all(p == 0 for p in predict[-1]):
        next = [n2 - n1 for n1, n2 in zip(*[predict[-1][i:] for i in range(2)])]
        predict.append(next)

    predict[-1].append(0)
    for i in range(len(predict) - 2, -1, -1):
        predict[i].append(predict[i + 1][-1] + predict[i][-1])

    return predict[0][-1]


def main():
    report = read_input()
    next_sum = 0
    for value_history in report:
        next_sum += predict_next(value_history)
    print(next_sum)


if __name__ == "__main__":
    main()
