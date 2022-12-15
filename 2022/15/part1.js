#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

import "../../utils/commons.js";

//const Y_SEARCH = 10;
const Y_SEARCH = 2000000;

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
const beacons = new Set(
  coords.map(([, , bx, by]) => {
    return [bx, by].toString();
  })
);

const [xmin, xmax] = sensors
  .map(([[x], dist]) => [x - dist, x + dist])
  .flat()
  .minmax();

let covered = new Set();
for (let x = xmin; x <= xmax; ++x) {
  const posSearch = [x, Y_SEARCH];
  if (beacons.has(posSearch.toString())) continue;

  const coveredBySensor = sensors.some(([pos, dist]) => {
    return manhattanDist(posSearch, pos) <= dist;
  });
  if (coveredBySensor) covered.add(posSearch.toString());
}

console.log(covered.size);
