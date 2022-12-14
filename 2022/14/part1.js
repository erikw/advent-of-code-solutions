#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import { create, all, Complex } from "mathjs";
const math = create(all, {});

import { DefaultMap, range } from "../../utils/commons.js";

const SYM = {
  ROCK: "#",
  SAND: "o",
  AIR: ".",
  SOURCE: "+",
};

const POS_SOURCE = math.complex(500, 0);

Complex.prototype.key = function () {
  return this.toString();
};

const printMap = (map) => {
  const [xmin, xmax] = Array.from(map.keys())
    .map((c) => math.complex(c).re)
    .minmax();
  const [ymin, ymax] = Array.from(map.keys())
    .map((c) => math.complex(c).im)
    .minmax();

  range(ymin, ymax + 1).forEach((y) => {
    range(xmin, xmax + 1).forEach((x) => {
      const pos = math.complex(x, y);
      process.stdout.write(map.get(pos.key()));
    });
    process.stdout.write("\n");
  });
  process.stdout.write("\n");
};

const DIR_DELTAS = [
  math.complex(0, 1),
  math.complex(-1, 1),
  math.complex(1, 1),
];

const nextSandPos = (map, pos) => {
  return DIR_DELTAS.map((d) => pos.add(d)).find(
    (p) => map.get(p.key()) == SYM.AIR
  );
};

let rockPoints = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((line) => {
    return Array.from(line.matchAll(/\d+,\d+/g), (m) =>
      m[0].split(",").map((d) => Number.parseInt(d, 10))
    );
  });

const map = new DefaultMap(() => SYM.AIR);
map.set(POS_SOURCE.key(), SYM.SOURCE);

rockPoints.forEach((rock) => {
  rock.eachCons(2, ([a, b]) => {
    if (a[0] == b[0]) {
      const x = a[0];
      const rng = [a[1], b[1]].sort((a, b) => a - b);
      rng[1]++;
      range(...rng).forEach((y) => {
        const pos = math.complex(x, y);
        map.set(pos.key(), SYM.ROCK);
      });
    } else {
      const y = a[1];
      const rng = [a[0], b[0]].sort((a, b) => a - b);
      rng[1]++;
      range(...rng).forEach((x) => {
        const pos = math.complex(x, y);
        map.set(pos.key(), SYM.ROCK);
      });
    }
  });
});

const maxY = [...map.keys()].map((p) => math.complex(p).im).max();
let sandFlows = true;
while (sandFlows) {
  let pos = POS_SOURCE.clone();
  let nextPos = nextSandPos(map, pos);
  while (nextPos && nextPos.im < maxY) {
    pos = nextPos;
    nextPos = nextSandPos(map, pos);
  }
  if (nextPos && nextPos.im >= maxY) {
    sandFlows = false;
  } else {
    map.set(pos.key(), SYM.SAND);
  }
}

const sandResting = [...map.values()].count((s) => s == SYM.SAND);
console.log(sandResting);
