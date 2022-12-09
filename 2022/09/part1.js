#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import { create, all } from "mathjs";
const math = create(all, {});

import { range, repeat } from "../../utils/commons.js";

const SYM = {
  HEAD: "H",
  TAIL: "T",
  START: "s",
  VISITED: "#",
  EMPTY: ".",
};

const DIR_STEPS = {
  U: math.complex(-1, 0),
  R: math.complex(0, 1),
  D: math.complex(1, 0),
  L: math.complex(0, -1),
};

const move = (posHead, posTail, visitedTail, dir) => {
  posHead = math.add(posHead, DIR_STEPS[dir]);
  const diff = math.subtract(posHead, posTail);
  if (Math.abs(diff.re) > 1 || Math.abs(diff.im) > 1) {
    // If re > 1 -> re=1, re < -1 -> re=-1. Same for im.
    diff.re = diff.re == 0 ? 0 : diff.re / Math.abs(diff.re);
    diff.im = diff.im == 0 ? 0 : diff.im / Math.abs(diff.im);
    posTail = posTail.add(diff);
    visitedTail.add(posTail.toString());
  }
  return [posHead, posTail];
};

const printGrid = (posHead, posTail, visitedTail) => {
  const posOrigin = math.complex(0, 0);
  const posVisited = Array.from(visitedTail.values()).map((s) =>
    math.complex(s)
  );
  const posAll = [posOrigin, posHead, posTail, ...posVisited];

  const [xmin, xmax] = posAll.map((c) => c.re).minmax();
  const [ymin, ymax] = posAll.map((c) => c.im).minmax();

  range(xmin, xmax + 1).forEach((x) => {
    range(ymin, ymax + 1).forEach((y) => {
      const pos = math.complex(x, y);
      if (pos.equals(posHead)) {
        process.stdout.write(SYM.HEAD);
      } else if (pos.equals(posTail)) {
        process.stdout.write(SYM.TAIL);
      } else if (pos.equals(posOrigin)) {
        process.stdout.write(SYM.START);
      } else if (visitedTail.has(pos.toString())) {
        process.stdout.write(SYM.VISITED);
      } else {
        process.stdout.write(SYM.EMPTY);
      }
    });
    process.stdout.write("\n");
  });
  process.stdout.write("\n");
};

let moves = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split(" "))
  .map(([dir, dist]) => [dir, Number.parseInt(dist, 10)]);

const visitedTail = new Set();

let posHead = math.complex(0, 0);
let posTail = math.complex(0, 0);

visitedTail.add(posTail.toString());

moves.forEach(([dir, dist]) => {
  repeat(dist, () => {
    [posHead, posTail] = move(posHead, posTail, visitedTail, dir);
    //printGrid(posHead, posTail, visitedTail);
  });
});

console.log(visitedTail.size);
