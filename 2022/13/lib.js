import { readFileSync } from "node:fs";

export const readInput = () => {
  return readFileSync(process.argv[2])
    .toString()
    .trimEnd()
    .split("\n\n")
    .map((pairLines) => {
      return pairLines.split("\n").map((l) => eval(l));
    });
};

export const cmp = (left, right) => {
  let i = 0;
  while (i < left.length && i < right.length) {
    if (Number.isInteger(left[i]) && Number.isInteger(right[i])) {
      if (left[i] == right[i]) {
        i++;
      } else {
        return left[i] - right[i];
      }
    } else {
      const recRes = cmp([left[i]].flat(), [right[i]].flat());
      if (recRes == 0) {
        i++;
      } else {
        return recRes;
      }
    }
  }
  return left.length - right.length;
};
