#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

import "../../utils/commons.js";

const XY_MIN = 0;
//const XY_MAX = 20;
const XY_MAX = 4000000;

const TUNING_FACTOR = 4000000;

const manhattanDist = (p1, p2) => {
  return (p1[0] - p2[0]).abs() + (p1[1] - p2[1]).abs();
};

const coords = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((line) => {
    return Array.from(line.matchAll(/-?\d+/g), (d) => Number.parseInt(d, 10));
  });

const sensors = coords.map(([sx, sy, bx, by]) => {
  return [[sx, sy], manhattanDist([sx, sy], [bx, by])];
});

// Hats off to
// * https://www.reddit.com/r/adventofcode/comments/zmcn64/comment/j0b90nr/
// * https://imgur.com/gzLuUgF
const coeffAscendingLines = new Set();
const coeffDescendingLines = new Set();
sensors.forEach(([[x, y], radius]) => {
  coeffAscendingLines.add(y - x + radius + 1);
  coeffAscendingLines.add(y - x - radius - 1);
  coeffDescendingLines.add(y + x + radius + 1);
  coeffDescendingLines.add(y + x - radius - 1);
});

for (const ascCoeff of coeffAscendingLines) {
  for (const descCoeff of coeffDescendingLines) {
    const posIntersect = [
      ((descCoeff - ascCoeff) / 2).floor(),
      ((descCoeff + ascCoeff) / 2).floor(),
    ];
    if (!posIntersect.every((c) => c.inRange(XY_MIN, XY_MAX))) continue;

    const outsideAllCircles = sensors.every(([sensor, radius]) => {
      const distIntersectSensor = manhattanDist(posIntersect, sensor);
      return distIntersectSensor > radius;
    });

    if (outsideAllCircles) {
      const tuningFreq = posIntersect[0] * TUNING_FACTOR + posIntersect[1];
      console.log(tuningFreq);
      process.exit(0);
    }
  }
}
