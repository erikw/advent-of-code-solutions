#!/usr/bin/env python3
import fileinput


class HashMap:
    OP_DASH = "-"
    OP_EQUAL = "="
    NO_BOXES = 256

    def __init__(self):
        self._boxes = [[] for _ in range(HashMap.NO_BOXES)]

    @staticmethod
    def _hash(step):
        value = 0
        for char in step:
            value += ord(char)
            value *= 17
            value %= 256
        return value

    def _insert(self, label, focal_length):
        hash = HashMap._hash(label)
        box = self._boxes[hash]

        i = 0
        while i < len(box) and box[i][0] != label:
            i += 1

        if i < len(box) and box[i][0] == label:
            box[i][1] = focal_length
        else:
            box.append([label, focal_length])

    def _remove(self, label):
        hash = HashMap._hash(label)
        box = self._boxes[hash]
        for i in range(len(box)):
            if box[i][0] == label:
                del box[i]
                break

    def _box_str(self, box_idx):
        return " ".join(
            [f"[{lens} {focal_len}]" for lens, focal_len in self._boxes[box_idx]]
        )

    def __str__(self):
        boxes = "\n".join(
            [
                f"Box {i}: {self._box_str(i)}"
                for i in range(len(self._boxes))
                if len(self._boxes[i]) > 0
            ]
        )
        return "HashMap:\n" + boxes

    __repr__ = __str__

    def exec_operation(self, operation):
        if operation[-1] == HashMap.OP_DASH:
            label = operation[:-1]
            self._remove(label)
        elif operation[-2] == HashMap.OP_EQUAL:
            label, focal_length = operation.split(HashMap.OP_EQUAL)
            self._insert(label, int(focal_length))
        else:
            raise ValueError("Unsupported operation step sequence.")

    def focus_power(self):
        power = 0
        for box_idx, box in enumerate(self._boxes):
            for slot_idx, [_lens, focal_length] in enumerate(box):
                power += (box_idx + 1) * (slot_idx + 1) * focal_length
        return power


def read_init_seq():
    return list(fileinput.input())[0].rstrip("\n").split(",")


def main():
    init_seq = read_init_seq()

    hashmap = HashMap()
    for step in init_seq:
        hashmap.exec_operation(step)
    print(hashmap.focus_power())


if __name__ == "__main__":
    main()
