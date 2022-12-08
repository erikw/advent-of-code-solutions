#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import { create, all } from "mathjs";
const math = create(all, {});

import { range } from "../../utils/commons.js";

const POS_DELTAS = [
  math.complex(0, -1),
  math.complex(0, 1),
  math.complex(-1, 0),
  math.complex(1, 0),
];

const visibleToEdge = (forest, pos_tree, step) => {
  let pos = math.add(pos_tree.clone(), step);
  while (
    pos.re.inRange(0, forest.length - 1) &&
    pos.im.inRange(0, forest[0].length - 1)
  ) {
    if (forest[pos.re][pos.im] < forest[pos_tree.re][pos_tree.im]) {
      pos = math.add(pos, step);
    } else {
      return false;
    }
  }
  return true;
};

const visibleAt = (forest, pos) => {
  return POS_DELTAS.some((step) => visibleToEdge(forest, pos, step));
};

let forest = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split("").map((c) => Number.parseInt(c, 10)));

let visible = 2 * (forest.length + forest[0].length) - 4;

range(1, forest.length - 1).forEach((row) => {
  range(1, forest[0].length - 1).forEach((col) => {
    const pos = math.complex(row, col);
    if (visibleAt(forest, pos)) visible++;
  });
});

console.log(visible);
