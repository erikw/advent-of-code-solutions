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

const KNOTS = 10;

const DIR_STEPS = {
  U: math.complex(-1, 0),
  R: math.complex(0, 1),
  D: math.complex(1, 0),
  L: math.complex(0, -1),
};

const printGrid = (posKnots, visitedTail) => {
  const posOrigin = math.complex(0, 0);
  const posVisited = Array.from(visitedTail.values()).map((s) =>
    math.complex(s)
  );
  const posAll = [posOrigin, ...posKnots, ...posVisited];

  const [xmin, xmax] = posAll.map((c) => c.re).minmax();
  const [ymin, ymax] = posAll.map((c) => c.im).minmax();

  range(xmin, xmax + 1).forEach((x) => {
    range(ymin, ymax + 1).forEach((y) => {
      const pos = math.complex(x, y);
      const knotsIdx = posKnots.findIndex((p) => p.equals(pos));
      if (knotsIdx == 0) {
        process.stdout.write(SYM.HEAD);
      } else if (knotsIdx != -1) {
        process.stdout.write(knotsIdx.toString());
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

const move = (posKnots, dir) => {
  posKnots[0] = math.add(posKnots[0], DIR_STEPS[dir]);
  for (let i = 1; i < KNOTS; i++) {
    const diff = math.subtract(posKnots[i - 1], posKnots[i]);
    if (Math.abs(diff.re) > 1 || Math.abs(diff.im) > 1) {
      // If re > 1 -> re=1, re < -1 -> re=-1. Same for im.
      diff.re = diff.re == 0 ? 0 : diff.re / Math.abs(diff.re);
      diff.im = diff.im == 0 ? 0 : diff.im / Math.abs(diff.im);
      posKnots[i] = posKnots[i].add(diff);
    } else {
      break;
    }
  }
};

let moves = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split(" "))
  .map(([dir, dist]) => [dir, Number.parseInt(dist, 10)]);

const posKnots = Array.apply(null, Array(KNOTS)).map(() => math.complex(0, 0));
const visitedTail = new Set();
visitedTail.add(posKnots.at(-1).toString());

moves.forEach(([dir, dist]) => {
  repeat(dist, () => {
    move(posKnots, dir);
    visitedTail.add(posKnots.at(-1).toString());
    //printGrid(posKnots, visitedTail);
  });
});

console.log(visitedTail.size);
