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

const scenicScoreToEdge = (forest, pos_tree, step) => {
  let pos = math.add(pos_tree.clone(), step);
  let visible = 0;
  while (
    pos.re.inRange(0, forest.length - 1) &&
    pos.im.inRange(0, forest[0].length - 1)
  ) {
    visible++;
    if (forest[pos.re][pos.im] >= forest[pos_tree.re][pos_tree.im]) {
      break;
    } else {
      pos = math.add(pos, step);
    }
  }
  return visible;
};

const scenicScore = (forest, pos) => {
  return POS_DELTAS.map((delta) => scenicScoreToEdge(forest, pos, delta)).mul();
};

let forest = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split("").map((c) => Number.parseInt(c, 10)));

let scores = [];
range(0, forest.length).forEach((row) => {
  range(0, forest[0].length).forEach((col) => {
    const pos = math.complex(row, col);
    scores.push(scenicScore(forest, pos));
  });
});

console.log(scores.max());
