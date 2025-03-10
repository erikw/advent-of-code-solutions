#!/usr/bin/env python3
import fileinput


def read_input():
    return [[int(d) for d in l.rstrip("\n").split(" ")] for l in fileinput.input()]


def predict_prev(value_history):
    predict = [value_history]

    while not all(p == 0 for p in predict[-1]):
        next = [n2 - n1 for n1, n2 in zip(*[predict[-1][i:] for i in range(2)])]
        predict.append(next)

    predict[-1].insert(0, 0)
    for i in range(len(predict) - 2, -1, -1):
        predict[i].insert(0, predict[i][0] - predict[i + 1][0])

    return predict[0][0]


def main():
    report = read_input()
    prev_sum = 0
    for value_history in report:
        prev_sum += predict_prev(value_history)
    print(prev_sum)


if __name__ == "__main__":
    main()
