#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

const pairRanges = readFileSync(process.argv[2])
  .toString()
  .trim()
  .split("\n")
  .map((line) => {
    return Array.from(line.matchAll(/\d+/g), (d) => Number.parseInt(d, 10));
  });

const overlapping = pairRanges.filter(([start1, end1, start2, end2]) => {
  return (
    (start2 <= end1 && start2 >= start1) || (start1 <= end2 && start1 >= start2)
  );
}).length;

console.log(overlapping);
